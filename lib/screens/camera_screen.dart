import 'dart:io';

import 'package:camera/camera.dart';
import 'package:collector/global/Global.dart';
import 'package:collector/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    // TODO: implement initState

    _initCamera();

    if (_cameras.length > 0) {
      _controller = CameraController(_cameras[0], ResolutionPreset.max);
      _initializeControllerFuture = _controller!.initialize();
    } else {
      _initializeControllerFuture = Future<void>.error((_) => {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (_controller != null) {
                  return Positioned(
                    top: 0,
                    bottom: 0,
                    child: CameraPreview(_controller!),
                  );
                } else {
                  return Container(
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        'Camera Not Available',
                        style: TextStyle(
                          color: CupertinoColors.systemRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
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
                  label: Text('293 NW'),
                  backgroundColor:
                      Global.colors.lightIconColor.withOpacity(0.5),
                ),
                Chip(
                  label: Text('53.2734, 53.2734'),
                  backgroundColor:
                      Global.colors.lightIconColor.withOpacity(0.5),
                ),
                Chip(
                  label: Text('824 ± 28ft'),
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

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
  }

  Future<void> _setupCamera() async {
    if (cameras.length <= 0) return;

    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(
      cameras[0],
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();
    } on CameraException catch (e) {
      print(e);
    }
  }
}
