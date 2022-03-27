import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collector/global/Global.dart';
import 'package:collector/models/item.dart';
import 'package:collector/providers/settings_provider.dart';
import 'package:collector/utilities/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final String documentsFolder;
  const ItemCard({Key? key, required this.item, required this.documentsFolder})
      : super(key: key);

  final bool _screenshotMode = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Global.colors.darkIconColor,
              ),
              child: Image.file(
                File('$documentsFolder/${item.photoPath}'),
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    item.title,
                    maxLines: 2,
                    maxFontSize: 24,
                    minFontSize: 12,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    '${item.dateTime.month}/${item.dateTime.day}/${item.dateTime.year}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Wrap(
                    spacing: 10,
                    children: [
                      Chip(
                        avatar: FaIcon(FontAwesomeIcons.locationCrosshairs),
                        label: Text(_screenshotMode && kDebugMode
                            ? '26.357891, 127.78378'
                            : '${item.latitude.toStringAsFixed(5)}, ${item.longitude.toStringAsFixed(5)}'),
                      ),
                      Chip(
                        avatar: FaIcon(FontAwesomeIcons.solidCompass),
                        label: Text(item.heading.cardinalDirection()),
                      ),
                      Chip(
                        avatar: FaIcon(FontAwesomeIcons.solidCompass),
                        label: Text(context
                                .read<SettingsProvider>()
                                .useMetricForAlt
                            ? '${item.altitude.round().toString()} m '
                            : '${(item.altitude * 3.28084).round().toString()} ft'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
