import 'package:adhan_dart/adhan_dart.dart';
import 'package:intl/intl.dart';

class PrayerService {
  static CalculationMethod _method = CalculationMethod.Makkah;

  static void init(CalculationMethod method) {
    _method = method;
  }

  static void updateCalculationMethod(CalculationMethod method) {
    _method = method;
  }

  static PrayerTimes getPrayerTimes(DateTime date, double latitude, double longitude) {
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationParameters(_method);
    return PrayerTimes(coordinates, date, params);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }
}
