import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:collector/global/Global.dart';
import 'package:collector/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  late List<CameraDescription> _cameras;
  StreamSubscription<Position>? _positionStream;
  late StreamSubscription<CompassEvent>? _compassStream;
  CameraController? _controller;
  FlashMode _flashMode = FlashMode.auto;

  late String _heading = "";
  late String _altitude = "";
  late String _position = "";

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    _setupGPS();
    _setupCamera();
  }

  @override
  void dispose() {
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
      case AppLifecycleState.inactive:
        _controller?.dispose();
        _controller = null;
        _positionStream?.cancel();
        _compassStream?.cancel();
        break;
      case AppLifecycleState.resumed:
        _setupGPS();
        _setupCamera();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onTap: () => Navigator.pushNamed(context, '/addItem'),
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
                    if (_flashMode == FlashMode.auto) {
                      setState(() {
                        _flashMode = FlashMode.always;
                      });
                    } else if (_flashMode == FlashMode.always) {
                      setState(() {
                        _flashMode = FlashMode.off;
                      });
                    } else {
                      _flashMode = FlashMode.auto;
                    }

                    _controller?.setFlashMode(_flashMode);
                  },
                  icon: Icon(
                    _flashMode == FlashMode.auto
                        ? Icons.flash_auto
                        : _flashMode == FlashMode.always
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

  void _setupPage() {
    // TODO: Permissions

    _setupCamera();
    _setupGPS();
  }

  Future<void> _setupCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.length < 1) {
        return;
      }
      _controller = CameraController(
        _cameras[0],
        ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await _controller?.initialize().then((_) async {
        await _controller?.lockCaptureOrientation(DeviceOrientation.portraitUp);
        if (mounted) {
          setState((() => {}));
        }
      });
    } catch (_) {}
  }

  Future<void> _setupGPS() async {
    // This handles the coordinates and altitude
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

    // This handles the heading
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
