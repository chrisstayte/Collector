import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collector/global/Global.dart';
import 'package:collector/main.dart';
import 'package:collector/models/item.dart';
import 'package:collector/providers/collector_provider.dart';
import 'package:collector/providers/settings_provider.dart';
import 'package:collector/utilities/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path/path.dart' as p;

class ItemScreen extends StatefulWidget {
  const ItemScreen({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  bool _screenshotMode = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          widget.item.title,
          maxLines: 1,
          minFontSize: 14,
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Share'),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                ),
              ),
            ],
            onSelected: (value) async {
              switch (value) {
                case 1:
                  await getTemporaryDirectory().then((value) {
                    File('$documentsFolder/${widget.item.photoPath}')
                        .copy('${value.path}/${widget.item.photoPath}')
                        .then((value2) {
                      Share.shareFiles(
                        [value2.path],
                        subject: 'Collector: ${widget.item.title}',
                        text:
                            '${widget.item.title}\n${widget.item.dateTime}\nHeading: ${widget.item.heading.cardinalDirection()}\nPosition: ${widget.item.latitude.toStringAsFixed(5)}, ${widget.item.longitude.toStringAsFixed(5)}\nAltitude: ${context.read<SettingsProvider>().useMetricForAlt ? '${widget.item.altitude.round().toString()} m ' : '${(widget.item.altitude * 3.28084).round().toString()} ft'}',
                      );
                    });
                  });
                  break;
                case 2:
                  await Navigator.pushNamed(
                    context,
                    '/editItem',
                    arguments: widget.item,
                  ).then(
                    (value) => setState(
                      () => {},
                    ),
                  );
                  break;
                case 3:
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Delete ${widget.item.title}',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => context
                                .read<CollectorProvider>()
                                .deleteItem(widget.item)
                                .then(
                                  (value) => Navigator.pushNamedAndRemoveUntil(
                                      context, '/', (_) => false),
                                ),
                            child: Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('No'),
                          )
                        ],
                      );
                    },
                  );
                  break;
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  Chip(
                    elevation: 5,
                    backgroundColor: Global.colors.lightIconColorDarker,
                    label: Text(
                      '${widget.item.dateTime.month}/${widget.item.dateTime.day}/${widget.item.dateTime.year}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Chip(
                    elevation: 5,
                    backgroundColor: Global.colors.lightIconColorDarker,
                    label: Text(
                      '${DateFormat('hh:mm a').format(widget.item.dateTime)}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              // Center(
              //   child: SizedBox(
              //     height: 400,
              //     child: widget.item.photoPath.isNotEmpty
              //         ? ClipRect(
              //             child: PhotoView(
              //               imageProvider: FileImage(
              //                 File('$documentsFolder/${widget.item.photoPath}'),
              //               ),
              //               enableRotation: true,
              //               backgroundDecoration: BoxDecoration(
              //                 color: Colors.transparent,
              //               ),
              //             ),
              //           )
              //         : null,
              //   ),
              // ),
              // Center(
              //   child: GestureDetector(
              //     onTap: () => Navigator.pushNamed(
              //       context,
              //       '/fullscreenImage',
              //       arguments: widget.item.photoPath,
              //     ),
              //     child: Hero(
              //       tag: 'image',
              //       child: Image.file(
              //         File('$documentsFolder/${widget.item.photoPath}'),
              //         height: 400,
              //       ),
              //     ),
              //   ),
              // ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      // MaterialPageRoute(
                      //   builder: (context) => HeroPhotoViewRouteWrapper(
                      //     imageProvider: FileImage(
                      //       File(
                      //         '$documentsFolder/${widget.item.photoPath}',
                      //       ),
                      //     ),
                      //     backgroundDecoration: BoxDecoration(
                      //       color: context.read<SettingsProvider>().isDarkMode
                      //           ? Global.colors.darkIconColor
                      //           : Global.colors.lightIconColor,
                      //     ),
                      //     minScale: PhotoViewComputedScale.contained * 0.8,
                      //     maxScale: PhotoViewComputedScale.covered * 1.5,
                      //   ),
                      // ),
                      PageTransition(
                        type: PageTransitionType.scale,
                        alignment: Alignment.center,
                        child: HeroPhotoViewRouteWrapper(
                          imageProvider: FileImage(
                            File(
                              '$documentsFolder/${widget.item.photoPath}',
                            ),
                          ),
                          backgroundDecoration: BoxDecoration(
                            color: context.read<SettingsProvider>().isDarkMode
                                ? Global.colors.darkIconColor
                                : Global.colors.lightIconColor,
                          ),
                          minScale: PhotoViewComputedScale.contained * 0.8,
                          maxScale: PhotoViewComputedScale.covered * 1.5,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    child: Hero(
                      tag: "image",
                      child: Image.file(
                        File('$documentsFolder/${widget.item.photoPath}'),
                        height: 450,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 44,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Coordinates',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _screenshotMode && kDebugMode
                              ? '26.357891,127.78378'
                              : '${widget.item.latitude.toStringAsFixed(5)}, ${widget.item.longitude.toStringAsFixed(5)}',
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Heading',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${widget.item.heading.cardinalDirection()}',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Altitude',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(context
                                      .read<SettingsProvider>()
                                      .useMetricForAlt
                                  ? '${widget.item.altitude.round().toString()} m '
                                  : '${(widget.item.altitude * 3.28084).round().toString()} ft')
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: widget.item.description.trim().isNotEmpty,
                child: Flexible(
                  flex: 1,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          widget.item.description,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  const HeroPhotoViewRouteWrapper({
    required this.imageProvider,
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final ImageProvider imageProvider;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: GestureDetector(
        onTapDown: (_) => Navigator.pop(context),
        child: PhotoView(
          imageProvider: imageProvider,
          backgroundDecoration: backgroundDecoration,
          enableRotation: true,
          minScale: minScale,
          maxScale: maxScale,
          disableGestures: false,
          heroAttributes: const PhotoViewHeroAttributes(tag: "image"),
        ),
      ),
    );
  }
}
