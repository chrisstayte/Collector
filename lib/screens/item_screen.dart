import 'package:collector/global/Global.dart';
import 'package:collector/models/item.dart';
import 'package:collector/providers/settings_provider.dart';
import 'package:collector/utilities/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        title: Text('${widget.item.title}'),
        actions: [
          IconButton(
            onPressed: () => print("edit item"),
            icon: Icon(
              Icons.edit,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: FaIcon(FontAwesomeIcons.share),
          )
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
                    height: 350,
                    width: 250,
                    color: Colors.blue,
                    child: Center(
                      child: Text('Image Goes Here'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
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
              Container(
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
              Container(
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
                        Text(context.read<SettingsProvider>().useMetricForAlt
                            ? '${widget.item.altitude.round().toString()} m '
                            : '${(widget.item.altitude * 3.28084).round().toString()} ft')
                      ],
                    ),
                  ),
                ),
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
