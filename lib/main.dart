import 'package:camera/camera.dart';
import 'package:collector/global/Global.dart';
import 'package:collector/models/addItemArguments.dart';
import 'package:collector/models/item.dart';
import 'package:collector/providers/collector_provider.dart';
import 'package:collector/providers/settings_provider.dart';
import 'package:collector/screens/add_item_screen.dart';
import 'package:collector/screens/camera_screen.dart';
import 'package:collector/screens/edit_item_screen.dart';
import 'package:collector/screens/home_screen.dart';
import 'package:collector/screens/item_screen.dart';
import 'package:collector/screens/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

late String documentsFolder;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getApplicationDocumentsDirectory().then(
    (value) => documentsFolder = value.path,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(),
        ),
        ChangeNotifierProvider<CollectorProvider>(
          lazy: false,
          create: (_) => CollectorProvider(),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collector',
      showSemanticsDebugger: false,
      debugShowCheckedModeBanner: false,
      themeMode: context.watch<SettingsProvider>().isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
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
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Global.colors.darkIconColor,
          foregroundColor: Global.colors.lightIconColor,
          actionsIconTheme: IconThemeData(
            color: Global.colors.darkIconColorLighter,
          ),
          iconTheme: IconThemeData(
            //color: Color(0XFF536372),
            color: Global.colors.darkIconColorLighter,
          ),
          titleTextStyle: TextStyle(
            color: Global.colors.lightIconColor,
            fontFamily: 'DiarioDeAndy',
            fontSize: 26,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Global.colors.darkIconColorLighter,
          ),
        ),
        scaffoldBackgroundColor: Global.colors.darkIconColor,
        cupertinoOverrideTheme: const NoDefaultCupertinoThemeData(
          textTheme:
              CupertinoTextThemeData(primaryColor: CupertinoColors.white),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: MaterialStateProperty.all(
            Global.colors.lightIconColor,
          ),
          trackColor: MaterialStateProperty.all(
            Global.colors.lightIconColorDarker,
          ),
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
            final args = settings.arguments as AddItemArguments;
            return PageTransition(
              child: AddItemScreen(newItemArguments: args),
              type: PageTransitionType.bottomToTop,
            );
          case '/item':
            final item = settings.arguments as Item;
            return PageTransition(
              child: ItemScreen(
                item: item,
              ),
              type: PageTransitionType.rightToLeft,
            );
          case '/editItem':
            final item = settings.arguments as Item;
            return PageTransition(
                child: EditItemScreen(item: item),
                type: PageTransitionType.rightToLeft);
          case '/settings':
            return PageTransition(
              child: SettingsScreen(),
              type: PageTransitionType.bottomToTop,
            );
        }
        return null;
      },
    );
  }
}
