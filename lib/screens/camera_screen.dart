import 'dart:io';

import 'package:camera/camera.dart';
import 'package:collector/global/Global.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    // TODO: implement initState

    // _controller = CameraController(

    //   ResolutionPreset.high,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black,
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
                    onPressed: () {},
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
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
}
