import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:collector/global/Global.dart';
import 'package:collector/main.dart';
import 'package:collector/models/add_item_arguments.dart';
import 'package:collector/providers/settings_provider.dart';
import 'package:collector/utilities/extensions.dart';
import 'package:collector/widgets/permissions_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  late List<CameraDescription> _cameras;
  StreamSubscription<Position>? _positionStream;
  StreamSubscription<CompassEvent>? _compassStream;
  CameraController? _controller;
  FlashMode _flashMode = FlashMode.auto;

  bool _screenshotMode = true;

  double _heading = 0.0;
  double _altitude = 0.0;
  double _latitude = 0.0;
  double _longitude = 0.0;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    // _setupGPS();
    // _setupCamera();
    _setupPage();
  }

  @override
  void dispose() async {
    WidgetsBinding.instance?.removeObserver(this);
    _controller?.dispose();
    _controller = null;
    _positionStream?.cancel();
    _compassStream?.cancel();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _controller?.dispose();
        _controller = null;
        _positionStream?.pause();
        _compassStream?.pause();
        break;
      case AppLifecycleState.resumed:
        // _setupGPS();
        // _setupCamera();
        _setupPage();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _controller?.value.isInitialized ?? false
              ? Positioned(
                  top: 0,
                  bottom: 0,
                  child: CameraPreview(
                    _controller!,
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (_controller != null) {
                        if (_controller!.value.isInitialized) {
                          if (!_controller!.value.isTakingPicture) {
                            await _controller?.takePicture().then(
                                  (value) => Navigator.pushNamed(
                                    context,
                                    '/addItem',
                                    arguments: AddItemArguments(
                                      photo: value,
                                      latitude: _latitude,
                                      longitude: _longitude,
                                      heading: _heading,
                                      altitude: _altitude,
                                    ),
                                  ),
                                );
                          }
                        }
                      }
                    },
                    child: Container(
                      height: 84,
                      width: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 3,
                          color: Global.colors.darkIconColor,
                        ),
                        color: Global.colors.lightIconColor.withOpacity(.5),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: IconButton(
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/settings');
                      _setupCamera(force: true);
                    },
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Visibility(
                  visible: context.watch<SettingsProvider>().showInfoOnCamera
                      ? context.watch<SettingsProvider>().showHeading
                      : false,
                  child: Chip(
                    label: SizedBox(
                      width: 60,
                      child: Text(
                        _heading.cardinalDirection(),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    avatar: FaIcon(
                      FontAwesomeIcons.solidCompass,
                    ),
                  ),
                ),
                Visibility(
                  visible: context.watch<SettingsProvider>().showInfoOnCamera
                      ? context.watch<SettingsProvider>().showPosition
                      : false,
                  child: Chip(
                    label: Text(_screenshotMode && kDebugMode
                        ? '26.357891,127.78378'
                        : '${_latitude.toStringAsFixed(5)}, ${_longitude.toStringAsFixed(5)}'),
                    avatar: FaIcon(
                      FontAwesomeIcons.locationCrosshairs,
                    ),
                  ),
                ),
                Visibility(
                  visible: context.watch<SettingsProvider>().showInfoOnCamera
                      ? context.watch<SettingsProvider>().showAltitude
                      : false,
                  child: Chip(
                    label: Text(context.read<SettingsProvider>().useMetricForAlt
                        ? '${_altitude.round().toString()} m '
                        : '${(_altitude * 3.28084).round().toString()} ft'),
                    avatar: FaIcon(
                      FontAwesomeIcons.circleChevronUp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 175,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (context.read<SettingsProvider>().flashMode ==
                        FlashMode.auto) {
                      context
                          .read<SettingsProvider>()
                          .setFlashMode(FlashMode.always);
                      _controller?.setFlashMode(FlashMode.always);
                    } else if (context.read<SettingsProvider>().flashMode ==
                        FlashMode.always) {
                      context
                          .read<SettingsProvider>()
                          .setFlashMode(FlashMode.off);
                      _controller?.setFlashMode(FlashMode.off);
                    } else {
                      context
                          .read<SettingsProvider>()
                          .setFlashMode(FlashMode.auto);
                      _controller?.setFlashMode(FlashMode.auto);
                    }
                  },
                  icon: Icon(
                    context.watch<SettingsProvider>().flashMode ==
                            FlashMode.auto
                        ? Icons.flash_auto
                        : context.read<SettingsProvider>().flashMode ==
                                FlashMode.always
                            ? Icons.flash_on
                            : Icons.flash_off,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: SizedBox(
                height: 45,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _setupPage() async {
    // TODO: Permissions

    bool hasAccessToLocation = false;
    bool hasAccessToCamera = false;

    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
    ].request();

    if (statuses[Permission.location]!.isGranted) {
      hasAccessToLocation = true;
    }

    if (statuses[Permission.camera]!.isGranted) {
      hasAccessToCamera = true;
    }

    if (!hasAccessToCamera || !hasAccessToLocation) {
      showGeneralDialog(
        context: context,
        pageBuilder: (_, __, ___) {
          return PermissionsDialog(
            cameraPermission: hasAccessToCamera,
            locationPermission: hasAccessToLocation,
          );
        },
        transitionBuilder: (_, anim, __, child) {
          Tween<Offset> tween;
          if (anim.status == AnimationStatus.reverse) {
            tween = Tween(begin: Offset(0, -1), end: Offset.zero);
          } else {
            tween = Tween(begin: Offset(0, 1), end: Offset.zero);
          }

          return SlideTransition(
            position: tween.animate(anim),
            child: FadeTransition(
              opacity: anim,
              child: child,
            ),
          );
        },
      );
    } else {
      _setupCamera();
      _setupGPS();
    }
  }

  Future<void> _setupCamera({bool force = false}) async {
    if (_controller != null && !force) return;

    try {
      _cameras = await availableCameras();
      if (_cameras.length < 1) {
        return;
      }
      _controller = CameraController(
        _cameras[0],
        context.read<SettingsProvider>().resolutionPreset,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );
      await _controller?.initialize().then((_) async {
        await _controller?.lockCaptureOrientation(DeviceOrientation.portraitUp);
        await _controller?.setFlashMode(_flashMode);
        if (mounted) {
          setState((() => {}));
        }
      }).onError((error, stackTrace) {
        debugPrint('camera initialize error: ${error?.toString()}');
      });
    } catch (_) {}
  }

  Future<void> _setupGPS() async {
    // This handles the coordinates and altitude
    if (_positionStream != null) {
      _positionStream!.resume();
    } else {
      _positionStream = Geolocator.getPositionStream().listen(
        (Position? position) {
          if (position != null) {
            setState(() {
              //_heading = position.heading.round().toString();
              _altitude = position.altitude;
              _latitude = position.latitude;
              _longitude = position.longitude;
            });
          }
        },
      );
    }

    // This handles the heading
    if (_compassStream != null) {
      _compassStream!.resume();
    } else {
      _compassStream = FlutterCompass.events?.listen((event) {
        setState(() {
          _heading = event.headingForCameraMode ?? 0.0;
        });
      });
    }
  }
}
