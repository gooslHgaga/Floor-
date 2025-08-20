import 'package:adan/core/services/adhan_calculation.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';

class PrayerTimesProvider with ChangeNotifier {
  PrayerTimes? _prayerTimes;
  CalculationMethod _method = CalculationMethod.um_al_qura;

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
