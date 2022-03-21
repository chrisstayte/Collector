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

  late String _heading = "";
  late String _altitude = "";
  late String _position = "";

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    WidgetsBinding.instance?.addObserver(this);
    _setupGPS();
    _setupCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _controller?.dispose();
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
            top: 80,
            left: 0,
            right: 0,
            child: Row(
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
                  backgroundColor:
                      Global.colors.lightIconColor.withOpacity(0.5),
                ),
                Chip(
                  label: Text(_position),
                  backgroundColor:
                      Global.colors.lightIconColor.withOpacity(0.5),
                ),
                Chip(
                  label: Text(
                    _altitude,
                  ),
                  backgroundColor:
                      Global.colors.lightIconColor.withOpacity(0.5),
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
                  onPressed: () => {},
                  icon: Icon(
                    Icons.flash_auto,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _setupCamera() async {
    try {
      _cameras = await availableCameras();
      _controller = CameraController(
        _cameras[0],
        ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      // await _controller?.initialize().then((_) => {
      //       if (mounted) {
      //         setState((() => {})
      //       }
      //     });

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
