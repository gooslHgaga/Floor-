import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static String? customAdhanPath;

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(initSettings);
  }

  static void setCustomAdhan(String path) {
    customAdhanPath = path;
  }

  static Future<void> schedulePrayerNotification(String title, DateTime time) async {
    await _notificationsPlugin.zonedSchedule(
      0,
      title,
      'وقت الصلاة',
      time,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'adhan_channel',
          'Adhan Notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: false,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    Duration delay = time.difference(DateTime.now());
    if (delay.isNegative) return;
    Future.delayed(delay, () async {
      if (customAdhanPath != null) {
        await _audioPlayer.play(DeviceFileSource(customAdhanPath!));
      }
    });
  }
}
