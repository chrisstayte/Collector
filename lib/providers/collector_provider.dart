import 'dart:convert';
import 'dart:io';

import 'package:collector/models/item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CollectorProvider extends ChangeNotifier {
  final String _fileName = 'collectoritems.json';

  List<Item> _collectorItems = [];
  List<Item> get collectorItems => _collectorItems;

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

  void addItem(Item item) async {
    _collectorItems.insert(0, item);
    notifyListeners();
    await _saveCollectorItems();
  }

  void deleteItem(Item item) async {
    _collectorItems.remove(item);
    notifyListeners();
    await _saveCollectorItems();
  }
}
