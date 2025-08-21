import 'package:geolocator/geolocator.dart';
import 'package:adhan_dart/adhan_dart.dart';

class AdhanService {
  static Future<PrayerTimes> calculate(CalculationMethod method) async {
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
    );

    final params = method.getParameters(); // تعديل: بدل calculationParameters
    final coords = Coordinates(pos.latitude, pos.longitude);
    final date = DateTime.now();

    return PrayerTimes(
      coordinates: coords,
      date: date,
      calculationParameters: params,
    );
  }
}
