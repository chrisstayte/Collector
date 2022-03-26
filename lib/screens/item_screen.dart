import 'package:collector/global/Global.dart';
import 'package:collector/models/item.dart';
import 'package:collector/providers/settings_provider.dart';
import 'package:collector/utilities/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/editItem',
              arguments: widget.item,
            ).then((value) => setState(() => {})),
            icon: Icon(
              Icons.edit,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Chip(
                elevation: 5,
                backgroundColor: Global.colors.lightIconColorDarker,
                label: Text(
                  '${widget.item.dateTime.month}/${widget.item.dateTime.day}/${widget.item.dateTime.year}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: PhysicalModel(
                  color: Colors.transparent,
                  elevation: 5,
                  child: Container(
                    height: 290,
                    width: 250,
                    color: Colors.blue,
                    child: Center(
                      child: Text('Image Goes Here'),
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
                          '${widget.item.latitude.toStringAsFixed(4)}, ${widget.item.longitude.toStringAsFixed(4)}',
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
