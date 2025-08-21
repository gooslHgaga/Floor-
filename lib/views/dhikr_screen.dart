import 'package:flutter/material.dart';
import 'package:adhan_dart/adhan_dart.dart';

class DhikrScreen extends StatelessWidget {
  final Prayer prayer;   // ✅ Prayer وليس PrayerName
  const DhikrScreen(this.prayer, {super.key});

  String getDhikr() => switch (prayer) {
        Prayer.fajr  => 'أذكار الصباح...',
        Prayer.dhuhr => 'أذكار بعد الظهر...',
        Prayer.asr   => 'أذكار بعد العصر...',
        Prayer.maghrib => 'أذكار بعد المغرب...',
        Prayer.isha  => 'أذكار بعد العشاء...',
      };

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: Text('أذكار ${prayer.name}')));
}
