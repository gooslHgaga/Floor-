import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class AnalogClock extends StatefulWidget {
  const AnalogClock({super.key, this.size = 150});
  final double size;

  @override
  State<AnalogClock> createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  late Timer _timer;
  DateTime _time = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _time = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.size, widget.size),
      painter: _ClockPainter(_time),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final DateTime time;
  _ClockPainter(this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = Colors.indigo.shade100
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);

    // الساعة
    final hourPaint = Paint()
      ..color = Colors.indigo
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final minutePaint = Paint()
      ..color = Colors.blueAccent
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final secondPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final hourAngle = 2 * pi * ((time.hour % 12 + time.minute / 60) / 12);
    final minuteAngle = 2 * pi * (time.minute / 60);
    final secondAngle = 2 * pi * (time.second / 60);

    canvas.drawLine(center, Offset(
      center.dx + radius * 0.5 * sin(hourAngle),
      center.dy - radius * 0.5 * cos(hourAngle),
    ), hourPaint);

    canvas.drawLine(center, Offset(
      center.dx + radius * 0.7 * sin(minuteAngle),
      center.dy - radius * 0.7 * cos(minuteAngle),
    ), minutePaint);

    canvas.drawLine(center, Offset(
      center.dx + radius * 0.8 * sin(secondAngle),
      center.dy - radius * 0.8 * cos(secondAngle),
    ), secondPaint);

    // مركز الساعة
    canvas.drawCircle(center, 5, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
