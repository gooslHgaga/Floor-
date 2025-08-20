import 'package:geolocator/geolocator.dart';
import 'package:adhan_dart/adhan_dart.dart';

class AdhanService {
  static Future<PrayerTimes> calculate(CalculationMethod method) async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    final params = method.getParameters();
    final coordinates = Coordinates(position.latitude, position.longitude);
    final date = DateComponents.from(DateTime.now());

    return PrayerTimes(
      coordinates,
      date,
      params,
      utcOffset: DateTime.now().timeZoneOffset.inHours.toDouble(),
    );
  }
}
