import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin _notifications =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  static Future<void> init() async {
    const AndroidInitializationSettings initAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await _notifications.initialize(
      const InitializationSettings(android: initAndroid),
    );
  }

  static Future<void> schedulePrayer(
      int id, String title, DateTime scheduled) async {
    final tzScheduled = scheduled.subtract(const Duration(minutes: 1));
    await _notifications.zonedSchedule(
      id,
      title,
      'حان الآن وقت الصلاة',
      tz.TZDateTime.from(tzScheduled, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'adan_ch',
          'أذان',
          channelDescription: 'تنبيهات الصلاة',
          importance: Importance.max,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('adan'),
          playSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
