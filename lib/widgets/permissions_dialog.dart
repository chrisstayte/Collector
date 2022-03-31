import 'package:auto_size_text/auto_size_text.dart';
import 'package:collector/global/Global.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsDialog extends StatefulWidget {
  const PermissionsDialog({
    Key? key,
    required this.cameraPermission,
    required this.locationPermission,
  }) : super(key: key);
  final bool cameraPermission;
  final bool locationPermission;

  @override
  State<PermissionsDialog> createState() => _PermissionsDialogState();
}

class _PermissionsDialogState extends State<PermissionsDialog>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Global.colors.lightIconColor,
          ),
          padding: EdgeInsets.all(15.0),
          height: 350,
          width: 320,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Permissions',
                style: Theme.of(context).textTheme.headline6,
              ),
              Text(
                  'These are the permissions the app requires to work properly. Please enable them to continue.'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: FaIcon(FontAwesomeIcons.camera)),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Camera',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                          AutoSizeText(
                            'Application can take photos',
                            maxLines: 3,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: widget.cameraPermission
                          ? Icon(
                              Icons.thumb_up_sharp,
                              color: Global.colors.darkIconColor,
                              size: 32,
                            )
                          : OutlinedButton(
                              onPressed: () {
                                openAppSettings();
                              },
                              child: Text('Continue'),
                            ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: FaIcon(
                      FontAwesomeIcons.locationCrosshairs,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                          AutoSizeText(
                            'Can tag photos with location',
                            maxLines: 3,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: widget.locationPermission
                          ? Icon(
                              Icons.thumb_up_sharp,
                              color: Global.colors.darkIconColor,
                              size: 32,
                            )
                          : OutlinedButton(
                              onPressed: () {
                                openAppSettings();
                              },
                              child: Text('Continue'),
                            ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/', (_) => false),
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Global.colors.darkIconColor,
                  ),
                  child: Center(
                    child: Text(
                      'Go Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
