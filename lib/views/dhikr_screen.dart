import 'package:flutter/material.dart';
import 'package:adhan_dart/adhan_dart.dart';

class DhikrScreen extends StatelessWidget {
  final PrayerName prayer;
  const DhikrScreen(this.prayer, {super.key});

  String getDhikr() {
    switch (prayer) {
      case PrayerName.fajr:
        return 'أذكار الصباح...';
      case PrayerName.dhuhr:
        return 'أذكار بعد الظهر...';
      case PrayerName.asr:
        return 'أذكار بعد العصر...';
      case PrayerName.maghrib:
        return 'أذكار بعد المغرب...';
      case PrayerName.isha:
        return 'أذكار بعد العشاء...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('أذكار ${prayer.arabicName}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            getDhikr(),
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
