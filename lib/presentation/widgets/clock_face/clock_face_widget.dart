import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/clock_provider.dart';
import 'light_hour_painter.dart';

class ClockFaceWidget extends ConsumerStatefulWidget {
  const ClockFaceWidget({super.key});

  @override
  ConsumerState<ClockFaceWidget> createState() => _ClockFaceWidgetState();
}

class _ClockFaceWidgetState extends ConsumerState<ClockFaceWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = ref.watch(lightHourProgressProvider);
    final currentTime = ref.watch(currentTimeProvider);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(240, 240),
          painter: LightHourPainter(
            progress: progress,
            currentTime: currentTime,
          ),
        );
      },
    );
  }
}
