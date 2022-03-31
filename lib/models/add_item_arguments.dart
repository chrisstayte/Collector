import 'package:camera/camera.dart';

class AddItemArguments {
  XFile photo;
  double latitude;
  double longitude;
  double heading;
  double altitude;

  AddItemArguments(
      {required this.photo,
      required this.latitude,
      required this.longitude,
      required this.heading,
      required this.altitude});
}
