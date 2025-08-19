import 'package:flutter/material.dart';
import 'dart:async';

class VerseSlider extends StatefulWidget {
  final List<String> verses;
  final Duration duration;

  const VerseSlider({super.key, required this.verses, this.duration = const Duration(seconds: 5)});

  @override
  State<VerseSlider> createState() => _VerseSliderState();
}

class _VerseSliderState extends State<VerseSlider> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late Timer timer;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    timer = Timer.periodic(widget.duration, (timer) {
      _controller.reverse().then((value) {
        setState(() {
          currentIndex = (currentIndex + 1) % widget.verses.length;
        });
        _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.yellow.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          widget.verses[currentIndex],
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown),
        ),
      ),
    );
  }
}
