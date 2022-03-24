import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:collector/global/Global.dart';
import 'package:collector/models/item.dart';
import 'package:collector/providers/collector_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              child: ListView.builder(
                itemCount:
                    context.watch<CollectorProvider>().collectorItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => {},
                    child: ItemCard(
                      key: Key(context
                          .watch<CollectorProvider>()
                          .collectorItems[index]
                          .photoPath),
                      item: context
                          .watch<CollectorProvider>()
                          .collectorItems[index],
                    ),
                  );
                },
              ),
            ),
            // Expanded(
            //   child: ListView(
            //     children: [
            //       GestureDetector(
            //         onTap: () => Navigator.pushNamed(
            //           context,
            //           '/item',
            //         ),
            //         child: ItemCard(),
            //       )
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Item item;
  const ItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Global.colors.darkIconColor,
                ),
                child: Image.file(
                  File(item.photoPath),
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: SizedBox(
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        item.title,
                        maxLines: 2,
                        maxFontSize: 24,
                        minFontSize: 12,
                        style: TextStyle(
                            color: Global.colors.darkIconColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                      Text(
                        item.dateTime.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Global.colors.darkIconColor,
                        ),
                      ),
                      Text(
                        '${item.latitude}, ${item.longitude}',
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
    );
  }
}
