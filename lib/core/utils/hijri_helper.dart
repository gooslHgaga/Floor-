// lib/core/utils/hijri_helper.dart
import 'package:hijri/hijri.dart';

String getTodayHijri() {
  final h = HijriCalendar.now();
  return '${h.hDay} ${h.longMonthName} ${h.hYear} هـ';
}
