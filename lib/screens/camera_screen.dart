import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:collector/global/Global.dart';
import 'package:collector/main.dart';
import 'package:collector/models/addItemArguments.dart';
import 'package:collector/providers/settings_provider.dart';
import 'package:collector/widgets/permissions_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
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

  late String _heading = "";
  late String _altitude = "";
  late String _position = "";

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
    print(state.toString());
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
                            await _controller?.takePicture().then((value) =>
                                Navigator.pushNamed(context, '/addItem',
                                    arguments: AddItemArguments(
                                        photo: value,
                                        latitude: 0.0,
                                        longitude: 0.0,
                                        heading: 0.0,
                                        altitude: 0.0)));
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
                    onPressed: () {},
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
                Chip(
                  label: SizedBox(
                    width: 60,
                    child: Text(
                      _heading,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  avatar: FaIcon(
                    FontAwesomeIcons.solidCompass,
                    color: Global.colors.darkIconColor,
                  ),
                  backgroundColor: Global.colors.lightIconColor,
                ),
                Chip(
                  label: Text(_position),
                  avatar: FaIcon(
                    FontAwesomeIcons.locationCrosshairs,
                    color: Global.colors.darkIconColor,
                  ),
                  backgroundColor: Global.colors.lightIconColor,
                ),
                Chip(
                  label: Text(_altitude),
                  avatar: FaIcon(
                    FontAwesomeIcons.circleArrowUp,
                    color: Global.colors.darkIconColor,
                  ),
                  backgroundColor: Global.colors.lightIconColor,
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
                  )),
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

  Future<void> _setupCamera() async {
    if (_controller != null) return;

    try {
      _cameras = await availableCameras();
      if (_cameras.length < 1) {
        return;
      }
      _controller = CameraController(
        _cameras[0],
        ResolutionPreset.high,
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
              _altitude = "${position.altitude.round().toString()}m";
              _position =
                  "${position.latitude.toStringAsFixed(4)},  ${position.longitude.toStringAsFixed(4)}";
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
        var cardinalDirection = '';
        if (event.heading != null) {
          if (event.heading! > 337.5 || event.heading! <= 22.5) {
            cardinalDirection = 'N';
          } else if (event.heading! > 22.5 && event.heading! <= 67.5) {
            cardinalDirection = 'NE';
          } else if (event.heading! > 67.5 && event.heading! <= 112.5) {
            cardinalDirection = 'E';
          } else if (event.heading! > 112.5 && event.heading! <= 157.5) {
            cardinalDirection = 'SE';
          } else if (event.heading! > 157.5 && event.heading! <= 202.5) {
            cardinalDirection = 'S';
          } else if (event.heading! > 202.5 && event.heading! <= 247.5) {
            cardinalDirection = 'SW';
          } else if (event.heading! > 247.5 && event.heading! <= 292.5) {
            cardinalDirection = 'W';
          } else if (event.heading! > 292.5 && event.heading! <= 337.5) {
            cardinalDirection = 'NW';
          }
        }
        setState(() {
          _heading =
              '${event.headingForCameraMode?.round().toString()} $cardinalDirection';
        });
      });
    }
  }
}
