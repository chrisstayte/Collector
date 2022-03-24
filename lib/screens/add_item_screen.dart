import 'dart:io';

import 'package:camera/camera.dart';
import 'package:collector/global/Global.dart';
import 'package:collector/models/item.dart';
import 'package:collector/models/addItemArguments.dart';
import 'package:collector/providers/collector_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key, required this.newItemArguments})
      : super(key: key);
  final AddItemArguments newItemArguments;

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final DateTime _dateTime = DateTime.now();
  String _titleTextBox = '';
  String _descriptionTextBox = '';

  @override
  void initState() {
    print(widget.newItemArguments.photo.path);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
        actions: [
          IconButton(
            onPressed: () {
              var trimmed = _titleTextBox.trim();
              if (trimmed.isNotEmpty) {
                Item item = Item(
                  title: _titleTextBox,
                  description: _descriptionTextBox,
                  dateTime: _dateTime,
                  photoPath: widget.newItemArguments.photo.path,
                  latitude: widget.newItemArguments.latitude,
                  longitude: widget.newItemArguments.longitude,
                  altitude: widget.newItemArguments.altitude,
                  heading: widget.newItemArguments.heading,
                );

                context.read<CollectorProvider>().addItem(item);

                Navigator.pop(context);
              } else {
                var snackBar = const SnackBar(
                  content: Text('Title required'),
                  duration: Duration(seconds: 2),
                  //action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(children: [
          // SizedBox(
          //   height: 250,
          //   child: Image.file(File(widget.newItemArguments.photo.path)),
          // ),
          TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            style:
                // subtitle1 was used because this is the default text theme of a 'listTile'
                Theme.of(context).textTheme.subtitle1?.copyWith(
                      overflow: TextOverflow.ellipsis,
                    ),
            decoration: InputDecoration(
              hintText: 'Title',
              hintStyle: Theme.of(context).textTheme.subtitle1,
              border: InputBorder.none,
            ),
            onChanged: (value) => setState(() => _titleTextBox = value),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Global.colors.darkIconColor,
          ),
          Expanded(
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Description',
                border: InputBorder.none,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
