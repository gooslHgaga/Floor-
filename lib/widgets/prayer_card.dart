import 'package:flutter/material.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:provider/provider.dart';
import 'package:adan/providers/prayer_times_provider.dart';
import 'package:adan/views/dhikr_screen.dart';

class PrayerCard extends StatelessWidget {
  final Prayer prayer;   // PrayerName → Prayer
  const PrayerCard(this.prayer, {super.key});

  IconData _iconData() {
    switch (prayer) {
      case Prayer.fajr:
        return Icons.wb_twilight;
      case Prayer.dhuhr:
        return Icons.wb_sunny;
      case Prayer.asr:
        return Icons.cloud;
      case Prayer.maghrib:
        return Icons.nights_stay_outlined;
      case Prayer.isha:
        return Icons.nightlight_round;
    }
  }

  @override
  Widget build(BuildContext context) {
    final time = context.select<PrayerTimesProvider, String>(
      (p) {
        final t = p.prayerTimes?.timeForPrayer(prayer);
        return t == null
            ? '--:--'
            : '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
      },
    );
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DhikrScreen(prayer)),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(_iconData(),
                  size: 36, color: Theme.of(context).primaryColor),
              const SizedBox(height: 6),
              Text(prayer.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              Text(time,
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
