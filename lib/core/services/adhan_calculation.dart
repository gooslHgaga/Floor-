import 'package:geolocator/geolocator.dart';
import 'package:adhan_dart/adhan_dart.dart';

class AdhanService {
  static Future<PrayerTimes> calculate(CalculationMethod method) async {
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
      ),
    );

    final params = method.calculationParameters;   // parameters → calculationParameters
    final coordinates = Coordinates(position.latitude, position.longitude);
    final date = DateTime.now();

    return PrayerTimes(
      coordinates: coordinates,
      date: date,
      calculationParameters: params,
      // لا يوجد: utcOffset – يتم التعامل معه تلقائياً
    );
  }
}
