import 'package:flutter/material.dart';
import 'dart:math';

class CountdownRing extends StatelessWidget {
  final Duration remaining;
  final Duration total;
  final double size;

  const CountdownRing({
    super.key,
    required this.remaining,
    required this.total,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    double progress =
        total.inSeconds > 0 ? remaining.inSeconds / total.inSeconds : 0;
    progress = progress.clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(progress),
          ),
          Text(
            '${remaining.inHours.toString().padLeft(2,'0')}:'
            '${(remaining.inMinutes % 60).toString().padLeft(2,'0')}:'
            '${(remaining.inSeconds % 60).toString().padLeft(2,'0')}',
            style: TextStyle(
              fontSize: size * 0.22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;

  _RingPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 6.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final foregroundPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Colors.blueAccent, Colors.indigo],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    double angle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -pi / 2, angle, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
