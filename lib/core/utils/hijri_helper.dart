import 'package:jhijri/jhijri.dart';

String getTodayHijri() {
  final h = JHijri(fDate: DateTime.now());
  return '${h.day} ${h.longMonthName} ${h.year} هـ';
}
