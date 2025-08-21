import 'package:flutter/material.dart';
import 'package:adhan_dart/adhan_dart.dart';

class DhikrScreen extends StatelessWidget {
  final Prayer prayer;
  const DhikrScreen(this.prayer, {super.key});

  String getDhikr() {
    switch (prayer) {
      case Prayer.fajr:
        return 'أذكار الصباح...';
      case Prayer.dhuhr:
        return 'أذكار بعد الظهر...';
      case Prayer.asr:
        return 'أذكار بعد العصر...';
      case Prayer.maghrib:
        return 'أذكار بعد المغرب...';
      case Prayer.isha:
        return 'أذكار بعد العشاء...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('أذكار ${prayer.name}')),
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
