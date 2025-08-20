import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin _plugin =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  static Future<void> init() async {
    tz.initializeTimeZones();
    final String tzName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(tzName));

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(const InitializationSettings(android: androidInit));
  }

  static Future<void> schedulePrayer(int id, String title, DateTime dt) async {
    await _plugin.zonedSchedule(
      id,
      title,
      'حان الآن وقت الصلاة',
      tz.TZDateTime.from(dt.subtract(const Duration(minutes: 1)), tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_ch',
          'أذان',
          channelDescription: 'تنبيهات الصلاة',
          importance: Importance.max,
          priority: Priority.high,
          playSound: false,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
