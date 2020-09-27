import 'package:flutter/material.dart';
import 'dart:math';

class ProgressCircle extends CustomPainter {
  ProgressCircle({this.animation, this.strokeWidth, this.backgroundColor, this.color})
      : super(repaint: animation);

  final Animation<double> animation;

  final Color backgroundColor, color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paintBg = Paint()
      ..color = Colors.transparent//Colors.grey[200]
      ..strokeWidth = strokeWidth ?? 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Paint paintProgress = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = strokeWidth ?? 5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    paintBg.color = backgroundColor;
    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paintBg);

    paintProgress.color = color;
    double progress = (1.0 - animation.value) * 2 * pi;
    canvas.drawArc(Offset.zero & size, pi * 1.5, -progress, false, paintProgress);
  }

  @override
  bool shouldRepaint(ProgressCircle old) {
    return animation.value != old.animation.value || color != old.color || backgroundColor != old.backgroundColor;
  }
}
