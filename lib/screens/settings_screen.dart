import 'package:camera/camera.dart';
import 'package:collector/global/Global.dart';
import 'package:collector/providers/collector_provider.dart';
import 'package:collector/providers/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PackageInfo _packageInfo = PackageInfo(
      appName: 'Unknown',
      packageName: 'Unknown',
      version: 'Unknown',
      buildNumber: 'Unknown',
      buildSignature: 'Unknown');

  @override
  void initState() {
    _initPackageInfo();
    super.initState();
  }

  Future<void> _initPackageInfo() async {
    await PackageInfo.fromPlatform()
        .then((value) => setState(() => _packageInfo = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: FaIcon(FontAwesomeIcons.arrowDown),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'General',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          ListTile(
            title: Text('Dark Mode'),
            trailing: Switch(
              onChanged: (value) {
                context.read<SettingsProvider>().setIsDarkMode(value);
              },
              value: context.watch<SettingsProvider>().isDarkMode,
            ),
          ),
          ListTile(
            title: Text('Stay On Camera After New Item'),
            trailing: Switch(
              onChanged: (value) {
                context
                    .read<SettingsProvider>()
                    .setStayOnCameraAfterNewItem(value);
              },
              value: context.watch<SettingsProvider>().stayOnCameraAfterNewItem,
            ),
          ),
          ListTile(
            title: Text(
              'Camera',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          ListTile(
            title: Text('Photo Quality'),
            trailing: SizedBox(
              width: 225,
              child: CupertinoSegmentedControl(
                borderColor: context.watch<SettingsProvider>().isDarkMode
                    ? Global.colors.lightIconColor
                    : Global.colors.darkIconColor,
                unselectedColor: context.watch<SettingsProvider>().isDarkMode
                    ? Global.colors.darkIconColor
                    : Global.colors.lightIconColor,
                selectedColor: context.watch<SettingsProvider>().isDarkMode
                    ? Global.colors.lightIconColor
                    : Global.colors.darkIconColor,
                onValueChanged: (value) {
                  ResolutionPreset preset =
                      ResolutionPreset.values.byName(value!.toString());

                  context.read<SettingsProvider>().setResolutionPreset(preset);
                },
                groupValue:
                    context.watch<SettingsProvider>().resolutionPreset.name,
                children: {
                  ResolutionPreset.low.name: Text('Low'),
                  ResolutionPreset.medium.name: Text('Med'),
                  ResolutionPreset.high.name: Text('High')
                },
              ),
            ),
          ),
          ListTile(
            title: Text('Flash'),
            trailing: SizedBox(
              width: 225,
              child: CupertinoSegmentedControl(
                borderColor: context.watch<SettingsProvider>().isDarkMode
                    ? Global.colors.lightIconColor
                    : Global.colors.darkIconColor,
                unselectedColor: context.watch<SettingsProvider>().isDarkMode
                    ? Global.colors.darkIconColor
                    : Global.colors.lightIconColor,
                selectedColor: context.watch<SettingsProvider>().isDarkMode
                    ? Global.colors.lightIconColor
                    : Global.colors.darkIconColor,
                onValueChanged: (value) {
                  FlashMode flashMode =
                      FlashMode.values.byName(value!.toString());

                  context.read<SettingsProvider>().setFlashMode(flashMode);
                },
                groupValue: context.watch<SettingsProvider>().flashMode.name,
                children: {
                  FlashMode.auto.name: Text('Auto'),
                  FlashMode.always.name: Text('On'),
                  FlashMode.off.name: Text('Off'),
                },
              ),
            ),
          ),
          ListTile(
            title: Text(
              'Location',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          ListTile(
            title: Text(
              'Show Info On Camera Screen',
            ),
            trailing: Switch(
              onChanged: (value) {
                context.read<SettingsProvider>().setShowInfoOnCamera(value);
              },
              value: context.watch<SettingsProvider>().showInfoOnCamera,
            ),
          ),
          ListTile(
            title: Text(
              '      Show Heading',
            ),
            trailing: Switch(
              onChanged: context.watch<SettingsProvider>().showInfoOnCamera
                  ? (value) {
                      context.read<SettingsProvider>().setShowHeading(value);
                    }
                  : null,
              value: context.watch<SettingsProvider>().showHeading,
            ),
          ),
          ListTile(
            title: Text(
              '      Show Position',
            ),
            trailing: Switch(
              onChanged: context.watch<SettingsProvider>().showInfoOnCamera
                  ? (value) {
                      context.read<SettingsProvider>().setShowPosition(value);
                    }
                  : null,
              value: context.watch<SettingsProvider>().showPosition,
            ),
          ),
          ListTile(
            title: Text(
              '      Show Altitude',
            ),
            trailing: Switch(
              onChanged: context.watch<SettingsProvider>().showInfoOnCamera
                  ? (value) {
                      context.read<SettingsProvider>().setShowAltitude(value);
                    }
                  : null,
              value: context.watch<SettingsProvider>().showAltitude,
            ),
          ),
          ListTile(
            title: Text(
              'Use Metric For Altitude',
            ),
            trailing: Switch(
              onChanged: (value) {
                context.read<SettingsProvider>().setUseMetricForAlt(value);
              },
              value: context.watch<SettingsProvider>().useMetricForAlt,
            ),
          ),
          ListTile(
            title: Text(
              'Data',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.trashCan),
            title: Text('Delete All Data'),
            onTap: () => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Delete all items?'),
                  content: const Text('This is not reversable'),
                  actions: [
                    TextButton(
                      onPressed: () => context
                          .read<CollectorProvider>()
                          .deleteAllItems()
                          .then(
                            (value) => Navigator.pop(context),
                          ),
                      child: const Text('Yes'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('No'),
                    )
                  ],
                );
              },
            ),
          ),
          ListTile(
            title: Text(
              'FAQ',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.envelope),
            title: Text('collector@chrisstayte.com'),
            onTap: () async {
              final Uri params = Uri(
                scheme: 'mailto',
                path: 'collector@chrisstayte.com',
                query: 'subject=App Feedback (${_packageInfo.version})',
              );
              final String url = params.toString();
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
          ),
          // ListTile(
          //   leading: FaIcon(FontAwesomeIcons.fileLines),
          //   title: Text('Licenses'),
          //   onTap: () => Navigator.push(context, LicensePage()),
          // ),
          AboutListTile(
            icon: FaIcon(FontAwesomeIcons.fileLines),
            child: const Text('License'),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.github),
            title: Text('Repo'),
            onTap: () async {
              final Uri params = Uri(
                scheme: 'https',
                path: 'www.github.com/ChrisStayte/Collector',
              );
              final String url = params.toString();

              if (await canLaunch(url)) {
                await launch(url).catchError((error) {
                  print(error);
                  return false;
                });
              }
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.circleInfo),
            title: Text('${_packageInfo.version}'),
          )
        ],
      ),
    );
  }
}
