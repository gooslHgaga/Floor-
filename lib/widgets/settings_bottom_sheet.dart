import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adan/providers/prayer_times_provider.dart';
import 'package:adhan_dart/adhan_dart.dart';

void showSettingsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return ListView(
        shrinkWrap: true,
        children: CalculationMethod.values.map((m) => ListTile(
              title: Text(m.name()),
              onTap: () {
                context.read<PrayerTimesProvider>().changeMethod(m);
                Navigator.pop(context);
              },
            )).toList(),
      );
    },
  );
}
