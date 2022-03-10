import 'package:location/location.dart';

class Item {
  String title;
  String? description;
  Location location;
  DateTime dateTime;
  String photoPath;

  Item({
    required this.title,
    required this.location,
    required this.dateTime,
    required this.photoPath,
    this.description,
  });
}
