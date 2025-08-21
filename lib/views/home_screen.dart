```dart
import 'package:adan/widgets/ayah_rotator.dart';
import 'package:adan/widgets/date_row.dart';
import 'package:adan/widgets/next_prayer_banner.dart';
import 'package:adan/widgets/prayer_card.dart';
import 'package:adan/widgets/settings_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adan/providers/prayer_times_provider.dart';
import 'package:adan/providers/settings_provider.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:adan/core/services/audio_service.dart';
import 'package:adhan_dart/adhan_dart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final times = context.watch<PrayerTimesProvider>().prayerTimes;
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'أوقات الأذن',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const SizedBox(
                width: 120,
                height: 120,
                child: AnalogClock(
                  isKeepTime: true,
                  dialColor: Colors.transparent,
                  markingColor: Colors.white54,
                  hourNumberColor: Colors.white,
                  secondHandColor: Colors.red,
                  hourHandColor: Colors.white,
                  minuteHandColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const DateRow(),
              const AyahRotator(),
              const SizedBox(height: 12),
              const NextPrayerBanner(),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: Prayer.values.map((p) => PrayerCard(p)).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Switch(
                    value: settings.notificationsEnabled,
                    onChanged: (_) => settings.toggleNotifications(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.music_note),
                    onPressed: () => AudioService.pickExternal(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => showSettingsSheet(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```
