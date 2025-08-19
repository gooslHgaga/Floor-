import 'dart:async';
import 'package:flutter/material.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:intl/intl.dart';
import 'notification_service.dart';

class AppState extends ChangeNotifier {
  PrayerTimes? prayerTimes;
  String nextPrayerName = '';
  DateTime? nextPrayerTime;
  Duration timeUntilNextPrayer = Duration.zero;
  Timer? countdownTimer;
  Timer? verseTimer;
  int verseIndex = 0;
  bool notificationEnabled = false;
  String? customSound;

  List<String> quranVerses = [
    'وَأَقِيمُوا الصَّلَاةَ وَآتُوا الزَّكَاةَ وَارْكَعُوا مَعَ الرَّاكِعِينَ',
    'وَأَقِيمُوا الصَّلَاةَ وَآتُوا الزَّكَاةَ وَمَا تُقَدِّمُوا لِأَنفُسِكُم مِّن خَيْرٍ تَجِدُوهُ عِندَ اللَّهِ',
  ];

  void init() {
    computePrayerTimes();
    startCountdown();
    verseTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      verseIndex = (verseIndex + 1) % quranVerses.length;
      notifyListeners();
    });
  }

  void computePrayerTimes() {
    final coordinates = Coordinates(21.3891, 39.8579); // مكة
    final params = CalculationMethod.muslim_world_league();
    prayerTimes = PrayerTimes.today(coordinates, params);

    _updateNextPrayer();
  }

  void _updateNextPrayer() {
    if (prayerTimes == null) return;
    final now = DateTime.now();
    final prayers = {
      'الفجر': prayerTimes!.fajr,
      'الظهر': prayerTimes!.dhuhr,
      'العصر': prayerTimes!.asr,
      'المغرب': prayerTimes!.maghrib,
      'العشاء': prayerTimes!.isha,
    };
    nextPrayerName = '';
    nextPrayerTime = null;
    for (var entry in prayers.entries) {
      if (entry.value.isAfter(now)) {
        nextPrayerName = entry.key;
        nextPrayerTime = entry.value;
        break;
      }
    }
  }

  void startCountdown() {
    countdownTimer?.cancel();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (nextPrayerTime != null) {
        timeUntilNextPrayer = nextPrayerTime!.difference(DateTime.now());
        if (timeUntilNextPrayer.isNegative) {
          _updateNextPrayer();
          timeUntilNextPrayer = nextPrayerTime!.difference(DateTime.now());
        }
        notifyListeners();
      }
    });
  }

  void toggleNotification(bool value) {
    notificationEnabled = value;
    if (notificationEnabled) scheduleNotifications();
    notifyListeners();
  }

  void setCustomSound(String path) {
    customSound = path;
    notifyListeners();
  }

  void scheduleNotifications() {
    if (!notificationEnabled || prayerTimes == null) return;
    final prayers = {
      'الفجر': prayerTimes!.fajr,
      'الظهر': prayerTimes!.dhuhr,
      'العصر': prayerTimes!.asr,
      'المغرب': prayerTimes!.maghrib,
      'العشاء': prayerTimes!.isha,
    };
    int id = 0;
    prayers.forEach((name, time) {
      if (time.isAfter(DateTime.now())) {
        NotificationService.schedulePrayerNotification(
          id: id++,
          title: 'أذان $name',
          body: 'حان وقت الصلاة',
          scheduledTime: time,
          soundPath: customSound,
        );
      }
    });
  }
}
