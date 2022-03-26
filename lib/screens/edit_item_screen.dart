import 'package:collector/global/Global.dart';
import 'package:collector/models/item.dart';
import 'package:collector/providers/collector_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditItemScreen extends StatefulWidget {
  const EditItemScreen({Key? key, required this.item}) : super(key: key);
  final Item item;

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.item.title;
    _descriptionController.text = widget.item.description;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Item'),
        actions: [
          IconButton(
            onPressed: () {
              var trimmed = _titleController.text.trim();
              if (trimmed.isNotEmpty) {
                widget.item.title = _titleController.text;
                widget.item.description = _descriptionController.text;
                context.read<CollectorProvider>().editItem(widget.item).then(
                      (value) => Navigator.pop(context),
                    );
              } else {
                var snackBar = const SnackBar(
                  content: Text('Title required'),
                  duration: Duration(seconds: 2),
                  //action: SnackBarAction(label: 'Dismiss', onPressed: () {}),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: FaIcon(
              FontAwesomeIcons.check,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: _titleController,
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
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Global.colors.darkIconColor,
            ),
            Expanded(
              child: TextField(
                maxLines: null,
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
