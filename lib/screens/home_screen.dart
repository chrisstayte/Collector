import 'dart:io';

import 'package:collector/global/Global.dart';
import 'package:collector/main.dart';
import 'package:collector/models/sorting_method.dart';
import 'package:collector/providers/collector_provider.dart';
import 'package:collector/providers/settings_provider.dart';
import 'package:collector/widgets/item_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late String _searchText = '';

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        _searchText = _controller.text;
        context.read<CollectorProvider>().searchString = _controller.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onLongPress: () {
            if (kDebugMode) {
              context.read<CollectorProvider>().addDummyData();
            }
          },
          child: const Text('Collector'),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: DropdownButton(
            value: context.watch<SettingsProvider>().sortingMethod,
            onChanged: (value) {
              context
                  .read<SettingsProvider>()
                  .setSortingMethod(value as SortingMethod);
              context
                  .read<CollectorProvider>()
                  .sortItems(value as SortingMethod);
            },
            items: const [
              DropdownMenuItem<SortingMethod>(
                value: SortingMethod.dateAscending,
                child: FaIcon(FontAwesomeIcons.arrowDown19),
              ),
              DropdownMenuItem<SortingMethod>(
                value: SortingMethod.dateDescending,
                child: FaIcon(FontAwesomeIcons.arrowDown91),
              ),
              DropdownMenuItem<SortingMethod>(
                value: SortingMethod.alphaAscending,
                child: FaIcon(FontAwesomeIcons.arrowDownAZ),
              ),
              DropdownMenuItem<SortingMethod>(
                value: SortingMethod.alphaDescending,
                child: FaIcon(FontAwesomeIcons.arrowDownZA),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              icon: FaIcon(FontAwesomeIcons.gear))
        ],
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
              child: Card(
                elevation:
                    _focusNode.hasFocus || _searchText.isNotEmpty ? 3 : 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _searchText.isNotEmpty,
                        child: GestureDetector(
                          onTap: () {
                            _controller.clear();
                            _focusNode.unfocus();
                          },
                          child: Icon(
                            Icons.clear,
                          ),
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
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Delete ${context.read<CollectorProvider>().collectorItems[index].title}',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => context
                                    .read<CollectorProvider>()
                                    .deleteItem(context
                                        .read<CollectorProvider>()
                                        .collectorItems[index])
                                    .then(
                                      (value) => Navigator.pop(context),
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
                    },
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/item',
                      arguments: context
                          .read<CollectorProvider>()
                          .collectorItems[index],
                    ),
                    child: ItemCard(
                      key: Key(context
                          .read<CollectorProvider>()
                          .collectorItems[index]
                          .photoPath),
                      item: context
                          .read<CollectorProvider>()
                          .collectorItems[index],
                      documentsFolder: documentsFolder,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
