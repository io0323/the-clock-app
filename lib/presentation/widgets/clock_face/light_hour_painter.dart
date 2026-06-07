import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class LightHourPainter extends CustomPainter {
  final double progress;
  final DateTime currentTime;

  LightHourPainter({required this.progress, required this.currentTime});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;

    _drawOuterRing(canvas, center, radius);
    _drawProgressArc(canvas, center, radius - 12);
    _drawHourMarkers(canvas, center, radius - 12);
    _drawSecondDot(canvas, center, radius - 28);
    _drawCenterDot(canvas, center);
  }

  void _drawOuterRing(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = AppColors.aluminiumDark.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawCircle(center, radius, paint);
  }

  void _drawHourMarkers(Canvas canvas, Offset center, double radius) {
    final currentHour = currentTime.hour % 12;

    for (int i = 0; i < 12; i++) {
      final angle = (i * 2 * pi / 12) - pi / 2;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      if (i == currentHour) {
        final glowPaint = Paint()
          ..color = AppColors.amber
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(Offset(x, y), 5, glowPaint);

        final markerPaint = Paint()..color = AppColors.amber;
        canvas.drawCircle(Offset(x, y), 5, markerPaint);
      } else {
        final markerPaint = Paint()
          ..color = AppColors.aluminium.withValues(alpha: 0.3);
        canvas.drawCircle(Offset(x, y), 2.5, markerPaint);
      }
    }
  }

  void _drawProgressArc(Canvas canvas, Offset center, double radius) {
    final sweepAngle = progress * 2 * pi;
    if (sweepAngle <= 0) return;

    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: -pi / 2,
        endAngle: -pi / 2 + sweepAngle,
        colors: const [AppColors.amberDim, AppColors.amber],
        transform: const GradientRotation(-pi / 2),
      ).createShader(rect);

    canvas.drawArc(rect, -pi / 2, sweepAngle, false, paint);
  }

  void _drawSecondDot(Canvas canvas, Offset center, double radius) {
    final secondAngle = (currentTime.second * 2 * pi / 60) - pi / 2;
    final x = center.dx + radius * cos(secondAngle);
    final y = center.dy + radius * sin(secondAngle);

    final paint = Paint()..color = AppColors.amberSoft.withValues(alpha: 0.7);
    canvas.drawCircle(Offset(x, y), 3, paint);
  }

  void _drawCenterDot(Canvas canvas, Offset center) {
    final paint = Paint()..color = AppColors.amber;
    canvas.drawCircle(center, 4, paint);
  }

  @override
  bool shouldRepaint(covariant LightHourPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.currentTime != currentTime;
  }
}
