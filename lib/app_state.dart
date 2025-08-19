import 'package:flutter/material.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'services/prayer_service.dart';

class AppState extends ChangeNotifier {
  CalculationMethod _method = CalculationMethod.Makkah;
  bool notificationsEnabled = true;

  CalculationMethod get method => _method;

  void setCalculationMethod(CalculationMethod newMethod) {
    _method = newMethod;
    PrayerService.updateCalculationMethod(newMethod);
    notifyListeners();
  }

  void toggleNotifications(bool value) {
    notificationsEnabled = value;
    notifyListeners();
  }

  void init() {
    PrayerService.init(_method);
  }
}
