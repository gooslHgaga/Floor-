import 'package:adan/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class AyahRotator extends StatefulWidget {
  const AyahRotator({super.key});

  @override
  State<AyahRotator> createState() => _AyahRotatorState();
}

class _AyahRotatorState extends State<AyahRotator> {
  int _index = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      setState(() => _index = (_index + 1) % AppStrings.quranicAyat.length);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        AppStrings.quranicAyat[_index],
        style: const TextStyle(fontSize: 14, color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}
