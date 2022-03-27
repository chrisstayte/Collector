import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:collector/models/item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CollectorProvider extends ChangeNotifier {
  final String _fileName = 'collectoritems.json';

  String _searchString = "";
  set searchString(String value) {
    _searchString = value;
    notifyListeners();
  }

  List<Item> _collectorItems = [];
  UnmodifiableListView<Item> get collectorItems => _searchString.isEmpty
      ? UnmodifiableListView<Item>(_collectorItems)
      : UnmodifiableListView(
          _collectorItems.where(
            (item) =>
                item.title.toLowerCase().contains(
                      _searchString.toLowerCase(),
                    ) ||
                item.description.toLowerCase().contains(
                      _searchString.toLowerCase(),
                    ),
          ),
        );

  CollectorProvider() {
    _loadCollectorItems();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  Future<void> _loadCollectorItems() async {
    try {
      File file = await _localFile;
      print(file.path);
      if (!await file.exists()) {
        return;
      }
      String stringFromFile = await file.readAsString();

      if (kDebugMode) {
        print('\n\nCollector Items\n$stringFromFile');
      }

      List<dynamic> parsedListJson = jsonDecode(stringFromFile);

      _collectorItems = List<Item>.from(
        parsedListJson.map(
          (e) => Item.fromJson(e),
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    notifyListeners();
  }

  Future<void> _saveCollectorItems() async {
    String collectorItems = jsonEncode(_collectorItems);
    File file = await _localFile;
    file.writeAsString(collectorItems);
  }

  Future<void> addItem(Item item) async {
    _collectorItems.insert(0, item);
    notifyListeners();
    await _saveCollectorItems();
  }

  Future<void> deleteItem(Item item) async {
    _collectorItems.remove(item);
    notifyListeners();
    await _saveCollectorItems();
  }

  Future<void> deleteAllItems() async {
    _collectorItems.clear();
    notifyListeners();
    await _saveCollectorItems();
  }

  Future<void> editItem(Item item) async {
    if (_collectorItems.contains(item)) {
      notifyListeners();
      _saveCollectorItems();
    }
  }

  Future<void> addDummyData() async {
    Item item = Item(
      title: 'Dummy ${_collectorItems.length + 1}',
      description: 'Description Text ${_collectorItems.length + 1}',
      photoPath: '',
      latitude: 0.0,
      longitude: 0.0,
      altitude: 0.0,
      heading: 0.0,
      dateTime: DateTime.now(),
    );

    _collectorItems.add(item);
    notifyListeners();
  }
}
