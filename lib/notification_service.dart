import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings);
  }

  static Future<void> showPrayerNotification({
    required int id,
    required String title,
    required String body,
    String? soundPath,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'azan_channel',
      'أذان',
      channelDescription: 'قناة إشعارات أوقات الصلاة',
      importance: Importance.max,
      priority: Priority.high,
      sound: soundPath != null ? RawResourceAndroidNotificationSound(soundPath) : null,
      playSound: true,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);
    await _notifications.show(id, title, body, notificationDetails);
  }

  static Future<void> schedulePrayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? soundPath,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'azan_channel',
      'أذان',
      channelDescription: 'قناة إشعارات أوقات الصلاة',
      importance: Importance.max,
      priority: Priority.high,
      sound: soundPath != null ? RawResourceAndroidNotificationSound(soundPath) : null,
      playSound: true,
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledTime.toLocal().toUtc(),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
