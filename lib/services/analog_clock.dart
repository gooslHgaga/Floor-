import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class AnalogClockView extends StatefulWidget {
  const AnalogClockView({super.key});

  @override
  State<AnalogClockView> createState() => _AnalogClockViewState();
}

class _AnalogClockViewState extends State<AnalogClockView> {
  late Timer timer;
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        dateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue.shade50,
        boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 8)],
      ),
      child: CustomPaint(
        painter: _ClockPainter(dateTime),
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final DateTime dateTime;
  _ClockPainter(this.dateTime);

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);
    final radius = min(centerX, centerY);

    final fillBrush = Paint()..color = Colors.white;
    final outlineBrush = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    final centerFillBrush = Paint()..color = Colors.blue;

    canvas.drawCircle(center, radius - 4, fillBrush);
    canvas.drawCircle(center, radius - 4, outlineBrush);

    final secHandBrush = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final minHandBrush = Paint()
      ..color = Colors.black
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final hourHandBrush = Paint()
      ..color = Colors.black
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final secHandX = centerX + 60 * sin(dateTime.second * 6 * pi / 180);
    final secHandY = centerY - 60 * cos(dateTime.second * 6 * pi / 180);

    final minHandX = centerX + 50 * sin(dateTime.minute * 6 * pi / 180);
    final minHandY = centerY - 50 * cos(dateTime.minute * 6 * pi / 180);

    final hourHandX = centerX + 40 * sin((dateTime.hour % 12 + dateTime.minute / 60) * 30 * pi / 180);
    final hourHandY = centerY - 40 * cos((dateTime.hour % 12 + dateTime.minute / 60) * 30 * pi / 180);

    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    canvas.drawCircle(center, 8, centerFillBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
