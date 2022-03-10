import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:collector/global/Global.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // CameraController controller;

  // Future<bool> _checkIfLocationIsAvailable() async {
  //   bool servicesEnabled;
  //   LocationPermission permission;

  //   servicesEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!servicesEnabled) {
  //     return Future.error('Location services are disabled');
  //   }

  //   permission = await GeolocatorPlatform.instance.checkPermission();

  //   if (permission == LocationPermission.denied) {
  //     permission = await GeolocatorPlatform.instance.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location services are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, cannot request permissions.');
  //   }

  //   return true;
  // }

  // Future<bool> _checkIfCameraIsAvailable() async {

  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collector'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.camera_alt,
        ),
        onPressed: () {
          print('open camera');
          Navigator.pushNamed(context, '/camera');
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 64,
              color: Global.colors.lightIconColor,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.search,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: true,
                        child: Icon(
                          Icons.clear,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/item',
                    ),
                    child: SizedBox(
                      height: 135,
                      child: Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Global.colors.darkIconColor,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        'Title',
                                        maxLines: 2,
                                        maxFontSize: 24,
                                        minFontSize: 12,
                                        style: TextStyle(
                                            color: Global.colors.darkIconColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24),
                                      ),
                                      Text(
                                        'Date',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Global.colors.darkIconColor,
                                        ),
                                      ),
                                      Text(
                                        'Position',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Global.colors.darkIconColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
