import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:collector/global/Global.dart';
import 'package:collector/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  late CameraController _controller;

  late String _heading = "";
  late String _altitude = "";
  late String _position = "";

  @override
  void initState() {
    _setupGPS();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // FutureBuilder<void>(
          //   future: _setupCamera(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       if (_controller != null) {
          //         return Positioned(
          //           top: 0,
          //           bottom: 0,
          //           child: CameraPreview(_controller),
          //         );
          //       }
          //     }
          //     return Center(
          //       child: CircularProgressIndicator(),
          //     );
          //   },
          // ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.close_outlined,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/addItem'),
                    child: Container(
                      height: 64,
                      width: 64,
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
                      Icons.flash_auto,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 150,
            left: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(
                  label: Text(_heading),
                  backgroundColor:
                      Global.colors.lightIconColor.withOpacity(0.5),
                ),
                Chip(
                  label: Text(_position),
                  backgroundColor:
                      Global.colors.lightIconColor.withOpacity(0.5),
                ),
                Chip(
                  label: Text(_altitude),
                  backgroundColor:
                      Global.colors.lightIconColor.withOpacity(0.5),
                ),
              ],
            ),
          )
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
      await _controller.initialize();
    } catch (_) {}
  }

  Future<void> _setupGPS() async {
    // bool _serviceEnabled;
    // PermissionStatus _permissionGranted;
    // LocationData _locationData;

    // _serviceEnabled = await location.serviceEnabled();
    // if (!_serviceEnabled) {
    //   _serviceEnabled = await location.requestService();
    //   if (!_serviceEnabled) {
    //     return;
    //   }
    // }

    // _permissionGranted = await location.hasPermission();
    // if (_permissionGranted == PermissionStatus.denied) {
    //   _permissionGranted = await location.requestPermission();
    //   if (_permissionGranted != PermissionStatus.granted) {
    //     return;
    //   }
    // }

    // _locationData = await location.getLocation();

    // location.changeSettings(
    //     accuracy: LocationAccuracy.high, interval: 100, distanceFilter: 0);

    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   setState(() {
    //     _heading = currentLocation.heading.toString();
    //     _altitude = currentLocation.altitude.toString();
    //     _position =
    //         "${currentLocation.latitude},  ${currentLocation.longitude}";
    //   });
    // });

    LocationSettings locationSettings = LocationSettings();
    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      (Position? position) {
        if (position != null) {
          setState(() {
            //_heading = position.heading.round().toString();
            _altitude =
                "${position.altitude.round().toString()} ± ${position.accuracy}";
            _position =
                "${position.latitude.toStringAsFixed(4)},  ${position.longitude.toStringAsFixed(4)}";
          });
        }
        print(
            "\n\nheading: $_heading\naltitude: $_altitude\nposition: $_position\n\n");
      },
    );

    FlutterCompass.events?.listen((event) {
      setState(() {
        _heading = event.heading?.round().toString() ?? "";
      });
    });
  }
}
