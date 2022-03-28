import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collector/global/Global.dart';
import 'package:collector/main.dart';
import 'package:collector/models/item.dart';
import 'package:collector/providers/collector_provider.dart';
import 'package:collector/providers/settings_provider.dart';
import 'package:collector/utilities/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
                  leading: Icon(Icons.textsms),
                  title: Text('Share SMS'),
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: Icon(Icons.email),
                  title: Text('Share Email'),
                ),
              ),
              PopupMenuItem(
                value: 3,
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                ),
              ),
              PopupMenuItem(
                value: 4,
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                ),
              ),
              PopupMenuItem(
                  value: 5,
                  child: ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Share'),
                  )),
            ],
            onSelected: (value) async {
              switch (value) {
                case 1:
                  await sendSMS(
                    message:
                        '${widget.item.title}\n${widget.item.dateTime}\nHeading: ${widget.item.heading.cardinalDirection()}\nPosition: ${widget.item.latitude.toStringAsFixed(5)}, ${widget.item.longitude.toStringAsFixed(5)}\nAltitude: ${context.read<SettingsProvider>().useMetricForAlt ? '${widget.item.altitude.round().toString()} m ' : '${(widget.item.altitude * 3.28084).round().toString()} ft'}',
                    recipients: [],
                  );
                  break;
                case 2:
                  final Uri params = Uri(
                    scheme: 'mailto',
                    query:
                        'subject= Collector - ${widget.item.title}&body=${widget.item.title}\n${widget.item.dateTime}\nHeading: ${widget.item.heading.cardinalDirection()}\nPosition: ${widget.item.latitude.toStringAsFixed(5)}, ${widget.item.longitude.toStringAsFixed(5)}\nAltitude: ${context.read<SettingsProvider>().useMetricForAlt ? '${widget.item.altitude.round().toString()} m ' : '${(widget.item.altitude * 3.28084).round().toString()} ft'}',
                  );

                  final String url = params.toString();
                  if (await canLaunch(url)) {
                    await (launch(url));
                  }
                  break;
                case 3:
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
                case 4:
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
                case 5:
                  await getTemporaryDirectory().then((value) {
                    print(p.basename(widget.item.photoPath));
                    File(widget.item.photoPath)
                        .copy('${value.path}')
                        .then((value2) {
                      Share.shareFiles(
                        [value2.path],
                        text:
                            '${widget.item.title}\n${widget.item.dateTime}\nHeading: ${widget.item.heading.cardinalDirection()}\nPosition: ${widget.item.latitude.toStringAsFixed(5)}, ${widget.item.longitude.toStringAsFixed(5)}\nAltitude: ${context.read<SettingsProvider>().useMetricForAlt ? '${widget.item.altitude.round().toString()} m ' : '${(widget.item.altitude * 3.28084).round().toString()} ft'}',
                      );
                    });
                  });

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

              Center(
                child: SizedBox(
                  height: 400,
                  child: ClipRect(
                    child: PhotoView(
                      imageProvider: FileImage(
                        File('$documentsFolder/${widget.item.photoPath}'),
                      ),
                      enableRotation: true,
                      backgroundDecoration: BoxDecoration(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              // SizedBox(
              //   height: 44,
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Padding(
              //           padding: EdgeInsets.only(right: 10),
              //           child: GestureDetector(
              //             onTap: () async {
              //               await sendSMS(
              //                 message: '${widget.item.title}',
              //                 recipients: [],
              //               );
              //             },
              //             child: Card(
              //               color: Global.colors.lightIconColorDarker,
              //               child: Center(
              //                 child: FaIcon(
              //                   FontAwesomeIcons.commentSms,
              //                   color: Colors.white,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Expanded(
              //         child: Padding(
              //           padding: EdgeInsets.only(left: 10),
              //           child: Card(
              //             color: Global.colors.lightIconColorDarker,
              //             child: Center(
              //               child: FaIcon(
              //                 FontAwesomeIcons.envelope,
              //                 color: Colors.white,
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
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
