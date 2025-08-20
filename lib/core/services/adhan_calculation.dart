import 'package:adhan_dart/adhan_dart.dart';
import 'package:geolocator/geolocator.dart';

class AdhanService {
  static Future<PrayerTimes> calculate(CalculationMethod method) async {
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    final params = method.getParameters();
    final coordinates = Coordinates(pos.latitude, pos.longitude);
    final date = DateComponents.from(DateTime.now());
    return PrayerTimes(coordinates, date, params, utcOffset: 3);
  }
}
