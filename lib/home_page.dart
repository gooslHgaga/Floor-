import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'prayer_times_service.dart';
import 'azkar_page.dart';
import 'countdown_ring.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final times = state.prayerTimes;

    // التاريخ الميلادي
    final now = DateTime.now();
    final gregorianDate = DateFormat('dd MMMM yyyy', 'ar').format(now);

    // التاريخ الهجري
    final hijri = HijriCalendar.now();
    final hijriDate =
        "${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} هـ";

    return Scaffold(
      appBar: AppBar(title: const Text('أوقات الأذان')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // عرض التاريخ الميلادي والهجري
            Column(
              children: [
                Text(
                  "التاريخ الميلادي: $gregorianDate",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                Text(
                  "التاريخ الهجري: $hijriDate",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // عرض آية قرآنية
            Text(
              state.quranVerses[state.verseIndex],
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.indigo,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            // قائمة أوقات الأذان
            Expanded(
              child: ListView(
                children: _buildPrayerCardsVector(context, state),
              ),
            ),

            // سويتش التنبيه
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('تنبيه الأذان'),
                Switch(
                  value: state.notificationEnabled,
                  onChanged: (val) => state.toggleNotification(val),
                ),
              ],
            ),

            // زر اختيار النغمة
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.audio,
                );
                if (result != null && result.files.isNotEmpty) {
                  final path = result.files.first.path;
                  if (path != null) state.setCustomSound(path);
                }
              },
              child: const Text('اختر نغمة من الهاتف'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPrayerCardsVector(BuildContext context, AppState state) {
    final times = state.prayerTimes;
    final items = <Map<String, DateTime?>>[
      {'الفجر': times?.fajr},
      {'الظهر': times?.dhuhr},
      {'العصر': times?.asr},
      {'المغرب': times?.maghrib},
      {'العشاء': times?.isha},
    ];

    return items.map((m) {
      final name = m.keys.first;
      final dt = m.values.first;
      final isNext = state.nextPrayerName == name;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Stack(
          children: [
            Container(
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: isNext
                    ? const LinearGradient(
                        colors: [Colors.indigo, Colors.blueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)
                    : LinearGradient(
                        colors: [Color(0xFFE8EAF6), Color(0xFFC5CAE9)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AzkarPage(prayerName: name),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getPrayerIcon(name),
                              color: isNext ? Colors.white : Colors.indigo,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(name,
                                    style: TextStyle(
                                        color: isNext
                                            ? Colors.white
                                            : Colors.indigo,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                if (dt != null)
                                  Text(
                                    '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                        color: isNext
                                            ? Colors.white70
                                            : Colors.indigo.shade700),
                                  ),
                              ],
                            ),
                          ],
                        ),
                        if (isNext && state.timeUntilNextPrayer > Duration.zero)
                          CountdownRing(
                            remaining: state.timeUntilNextPrayer,
                            total: state.nextPrayerTime!
                                .difference(DateTime.now()),
                            size: 50,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  IconData _getPrayerIcon(String name) {
    switch (name) {
      case 'الفجر':
        return Icons.wb_sunny_outlined;
      case 'الظهر':
        return Icons.brightness_high;
      case 'العصر':
        return Icons.wb_sunny;
      case 'المغرب':
        return Icons.sunset;
      case 'العشاء':
        return Icons.nightlight_round;
      default:
        return Icons.access_time;
    }
  }
}
