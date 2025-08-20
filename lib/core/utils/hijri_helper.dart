import 'package:jhijri/jhijri.dart';

String getTodayHijri() {
  final today = DateTime.now();
  final h = JHijri(fDate: today);
  return '${h.day} ${h.longMonthName} ${h.year} هـ';
}
