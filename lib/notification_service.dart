import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'prayer_times_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  static Future<void> schedulePrayerNotifications(PrayerTimesService service) async {
    final now = tz.TZDateTime.now(tz.local);

    // مثال: جدولة الفجر
    if (service.fajrTime != null) {
      final parts = service.fajrTime!.split(':');
      final fajr = tz.TZDateTime(
          tz.local, now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'الفجر',
        'حان الآن موعد الصلاة',
        fajr,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'prayer_channel',
            'أذان',
            channelDescription: 'تنبيهات الصلاة',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }

    // يمكنك إضافة باقي الصلوات بنفس الطريقة
  }
}
