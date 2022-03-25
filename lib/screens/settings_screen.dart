import 'package:camera/camera.dart';
import 'package:collector/global/Global.dart';
import 'package:collector/providers/collector_provider.dart';
import 'package:collector/providers/settings_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
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
              'Camera',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          ListTile(
            title: Text('Photo Quality'),
            trailing: SizedBox(
              width: 225,
              child: CupertinoSegmentedControl(
                borderColor: Global.colors.darkIconColor,
                unselectedColor: Global.colors.lightIconColor,
                selectedColor: Global.colors.darkIconColor,
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
                borderColor: Global.colors.darkIconColor,
                unselectedColor: Global.colors.lightIconColor,
                selectedColor: Global.colors.darkIconColor,
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
            onLongPress: () {
              context.read<CollectorProvider>().deleteAllItems();
            },
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
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.fileLines),
            title: Text('Licenses'),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.github),
            title: Text('Repo'),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.circleInfo),
            title: Text('Version Number'),
          )
        ],
      ),
    );
  }
}
