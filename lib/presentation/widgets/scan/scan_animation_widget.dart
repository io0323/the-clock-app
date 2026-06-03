import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ScanAnimationWidget extends StatefulWidget {
  const ScanAnimationWidget({super.key, required this.isScanning});

  final bool isScanning;

  @override
  State<ScanAnimationWidget> createState() => _ScanAnimationWidgetState();
}

class _ScanAnimationWidgetState extends State<ScanAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    if (widget.isScanning) _controller.repeat();
  }

  @override
  void didUpdateWidget(ScanAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isScanning && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isScanning) return const SizedBox(height: 120);

    return SizedBox(
      height: 120,
      width: 120,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _RipplePainter(progress: _controller.value),
          );
        },
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  _RipplePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (var i = 0; i < 3; i++) {
      final phase = (progress + i / 3) % 1.0;
      final radius = maxRadius * phase;
      final opacity = (1.0 - phase) * 0.2;

      final paint = Paint()
        ..color = AppColors.amber.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawCircle(center, radius, paint);
    }

    final dotPaint = Paint()..color = AppColors.amber;
    canvas.drawCircle(center, 3, dotPaint);
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
