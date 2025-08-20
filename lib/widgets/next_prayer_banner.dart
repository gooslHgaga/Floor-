import 'package:adan/providers/prayer_times_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NextPrayerBanner extends StatelessWidget {
  const NextPrayerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final times = context.watch<PrayerTimesProvider>().prayerTimes;
    if (times == null) return const SizedBox.shrink();
    final next = times.nextPrayer();
    final remaining = times.timeForPrayer(next);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'الصلاة القادمة: ${next.arabicName} بعد ${remaining.inMinutes} دقيقة',
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }
}
