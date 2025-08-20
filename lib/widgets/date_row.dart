import 'package:adan/core/utils/hijri_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRow extends StatelessWidget {
  const DateRow({super.key});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final miladi = DateFormat('EEEE d MMMM y', 'ar').format(today);
    final hijri = getTodayHijri();
    return Column(
      children: [
        Text(miladi, style: const TextStyle(fontSize: 14)),
        Text(hijri, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
