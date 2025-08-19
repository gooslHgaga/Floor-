import 'package:flutter/material.dart';
import 'package:adhan_dart/adhan_dart.dart';

class PrayerTimesService extends ChangeNotifier {
  String? fajrTime;
  String? dhuhrTime;
  String? asrTime;
  String? maghribTime;
  String? ishaTime;

  final Coordinates coordinates = Coordinates(15.352, 44.206); // مثال: عدن

  void calculatePrayerTimes() {
    final params = CalculationMethod.muslimWorldLeague();
    final now = DateTime.now();
    final prayerTimes = PrayerTimes(coordinates, now, params);

    fajrTime = prayerTimes.fajr.toString().substring(11,16);
    dhuhrTime = prayerTimes.dhuhr.toString().substring(11,16);
    asrTime = prayerTimes.asr.toString().substring(11,16);
    maghribTime = prayerTimes.maghrib.toString().substring(11,16);
    ishaTime = prayerTimes.isha.toString().substring(11,16);

    notifyListeners();
  }
}
