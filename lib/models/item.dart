class Item {
  String title;
  String description;
  DateTime dateTime;
  String photoPath;
  double latitude;
  double longitude;
  double heading;
  double altitude;

  Item({
    required this.title,
    required this.description,
    required this.dateTime,
    required this.photoPath,
    required this.latitude,
    required this.longitude,
    required this.heading,
    required this.altitude,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    String title = json['title'] as String;
    String description = json['description'] as String;
    DateTime dateTime = DateTime.parse(json['dateTime']);
    String photoPath = json['photoPath'] as String;
    double latitude = json['latitude'] as double;
    double longitude = json['longitude'] as double;
    double heading = json['heading'] as double;
    double altitude = json['altitude'] as double;

    return Item(
        title: title,
        description: description,
        dateTime: dateTime,
        photoPath: photoPath,
        latitude: latitude,
        longitude: longitude,
        heading: heading,
        altitude: altitude);
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'dateTime': dateTime.toString(),
        'photoPath': photoPath,
        'latitude': latitude,
        'longitude': longitude,
        'heading': heading,
        'altitude': altitude,
      };
}
