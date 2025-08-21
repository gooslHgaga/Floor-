import 'package:flutter/material.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:adan/core/services/adhan_calculation.dart';

class PrayerTimesProvider with ChangeNotifier {
  PrayerTimes? _prayerTimes;
  CalculationMethod _method = CalculationMethod.umm_al_qura; // تعديل: الاسم

  PrayerTimes? get prayerTimes => _prayerTimes;

  Future<void> calculateTimes() async {
    _prayerTimes = await AdhanService.calculate(_method);
    notifyListeners();
  }

  void changeMethod(CalculationMethod newMethod) {
    _method = newMethod;
    calculateTimes();
  }
}
