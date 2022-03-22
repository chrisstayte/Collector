class Item {
  String title;
  String? description;
  DateTime dateTime;
  String photoPath;

  Item({
    required this.title,
    required this.dateTime,
    required this.photoPath,
    this.description,
  });
}
