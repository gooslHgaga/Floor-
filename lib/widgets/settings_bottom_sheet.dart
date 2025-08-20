import 'package:adan/providers/prayer_times_provider.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showSettingsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return ListView(
        shrinkWrap: true,
        children: CalculationMethod.values.map((m) => ListTile(
              title: Text(methodArabicName(m)),
              onTap: () {
                context.read<PrayerTimesProvider>().changeMethod(m);
                Navigator.pop(context);
              },
            )).toList(),
      );
    },
  );
}

String methodArabicName(CalculationMethod m) {
  switch (m) {
    case CalculationMethod.um_al_qura:
      return 'أم القرى – مكة';
    case CalculationMethod.muslim_world_league:
      return 'رابطة العالم الإسلامي';
    case CalculationMethod.egyptian:
      return 'الهيئة المصرية العامة للمساحة';
    case CalculationMethod.karachi:
      return 'جامعة العلوم الإسلامية – كراتشي';
    case CalculationMethod.libya:
      return 'الهيئة العامة للمساحة – ليبيا';
    default:
      return 'أخرى';
  }
}
