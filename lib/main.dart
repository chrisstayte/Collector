import 'package:camera/camera.dart';
import 'package:collector/global/Global.dart';
import 'package:collector/screens/add_item_screen.dart';
import 'package:collector/screens/camera_screen.dart';
import 'package:collector/screens/home_screen.dart';
import 'package:collector/screens/item_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

// late List<CameraDescription> cameras;

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  // cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      showSemanticsDebugger: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Global.colors.lightIconColor,
        appBarTheme: AppBarTheme(
          color: Global.colors.lightIconColor,
          titleTextStyle: Theme.of(context).textTheme.headline5?.copyWith(
                color: Global.colors.darkIconColor,
              ),
          elevation: 0,
          iconTheme: IconThemeData(
            color: Global.colors.lightIconColorDarker,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Global.colors.darkIconColor),
        iconTheme: IconThemeData(
          color: Global.colors.darkIconColor,
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return PageTransition(
              child: HomeScreen(),
              type: PageTransitionType.leftToRight,
            );
          case '/camera':
            return PageTransition(
              child: CameraScreen(),
              type: PageTransitionType.bottomToTop,
            );
          case '/addItem':
            return PageTransition(
              child: AddItemScreen(),
              type: PageTransitionType.bottomToTop,
            );
          case '/item':
            return PageTransition(
              child: ItemScreen(),
              type: PageTransitionType.rightToLeft,
            );
        }
        return null;
      },
    );
  }
}
