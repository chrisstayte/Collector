import 'package:collector/global/Global.dart';
import 'package:flutter/material.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
        actions: [
          IconButton(
            onPressed: () {
              print("Save and go home");
            },
            icon: Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(children: [
          const TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Title',
              border: InputBorder.none,
            ),
          ),
          Divider(
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
