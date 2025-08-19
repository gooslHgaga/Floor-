import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../services/prayer_service.dart';
import '../services/notification_service.dart';
import '../widgets/analog_clock.dart';
import '../widgets/prayer_card.dart';
import '../widgets/verse_slider.dart';
import 'package:file_picker/file_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedAdhanName;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AppState>(context);

    // مثال إحداثيات مكة المكرمة
    final latitude = 21.3891;
    final longitude = 39.8579;
    final prayerTimes = PrayerService.getPrayerTimes(DateTime.now(), latitude, longitude);

    // الصلاة القادمة
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> prayers = [
      {"name": "الفجر", "time": prayerTimes.fajr},
      {"name": "الظهر", "time": prayerTimes.dhuhr},
      {"name": "العصر", "time": prayerTimes.asr},
      {"name": "المغرب", "time": prayerTimes.maghrib},
      {"name": "العشاء", "time": prayerTimes.isha},
    ];

    int nextPrayerIndex = prayers.indexWhere((p) => p["time"].isAfter(now));
    if (nextPrayerIndex == -1) nextPrayerIndex = 0;

    // آيات مثال
    final List<String> verses = [
      "وَأَقِيمُوا الصَّلَاةَ وَآتُوا الزَّكَاةَ وَأَمْرُوا بِالْمَعْرُوفِ وَنَهَوْا عَنِ الْمُنْكَرِ",
      "إِنَّ اللَّهَ وَمَلَائِكَتَهُ يُصَلُّونَ عَلَى النَّبِيِّ",
      "وَمَنْ أَحْيَاهَا فَكَأَنَّمَا أَحْيَا النَّاسَ جَمِيعًا",
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("أوقات الأذان"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const AnalogClockView(),
            const SizedBox(height: 12),
            VerseSlider(verses: verses),
            const SizedBox(height: 12),

            // Switch notifications
            SwitchListTile(
              title: const Text("تفعيل إشعارات الصلاة"),
              value: state.notificationsEnabled,
              onChanged: state.toggleNotifications,
            ),

            // اختيار نغمة الأذان
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("نغمة الأذان:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedAdhanName ?? "النغمة الافتراضية",
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.music_note),
                      label: const Text("اختيار"),
                      onPressed: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.audio);
                        if (result != null && result.files.single.path != null) {
                          NotificationService.setCustomAdhan(result.files.single.path!);
                          setState(() {
                            selectedAdhanName = result.files.single.name;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("تم اختيار نغمة الأذان بنجاح")),
                          );
                        }
                      },
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("تشغيل"),
                      onPressed: () async {
                        if (NotificationService.customAdhanPath != null) {
                          await NotificationService._audioPlayer.play(
                            DeviceFileSource(NotificationService.customAdhanPath!),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("النغمة الافتراضية سيتم تشغيلها")),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),

            // قائمة أوقات الصلاة
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: prayers.length,
              itemBuilder: (context, index) {
                final p = prayers[index];
                return PrayerCard(
                  prayerName: p["name"],
                  time: PrayerService.formatTime(p["time"]),
                  isNext: index == nextPrayerIndex,
                  onTap: () {
                    // يمكن الانتقال لصفحة الأذكار لكل صلاة
                  },
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
