import 'package:collector/global/Global.dart';
import 'package:collector/screens/camera_screen.dart';
import 'package:collector/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void main() {
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
          titleTextStyle: Theme.of(context).textTheme.headline4?.copyWith(
                color: Global.colors.darkIconColor,
              ),
          elevation: 0,
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
              type: PageTransitionType.rightToLeft,
            );
          case '/camera':
            return PageTransition(
              child: CameraScreen(),
              type: PageTransitionType.rightToLeft,
            );
        }
        return null;
      },
    );
  }
}
