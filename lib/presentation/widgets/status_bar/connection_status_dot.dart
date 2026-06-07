import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/ble_connection_status.dart';

class ConnectionStatusDot extends StatefulWidget {
  const ConnectionStatusDot({super.key, required this.status});

  final BleConnectionStatus status;

  @override
  State<ConnectionStatusDot> createState() => _ConnectionStatusDotState();
}

class _ConnectionStatusDotState extends State<ConnectionStatusDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _configureAnimation();
  }

  @override
  void didUpdateWidget(ConnectionStatusDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) {
      _controller.stop();
      _configureAnimation();
    }
  }

  void _configureAnimation() {
    switch (widget.status) {
      case BleConnectionStatus.connected:
      case BleConnectionStatus.scanning:
        _controller.duration = const Duration(milliseconds: 2000);
        _animation = CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        );
        _controller.repeat(reverse: true);
      case BleConnectionStatus.connecting:
        _controller.duration = const Duration(milliseconds: 800);
        _animation = CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        );
        _controller.repeat(reverse: true);
      case BleConnectionStatus.error:
      case BleConnectionStatus.lost:
        _controller.duration = const Duration(milliseconds: 600);
        _animation = CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        );
        _controller.repeat(reverse: true);
      case BleConnectionStatus.disconnected:
        _animation = const AlwaysStoppedAnimation(1.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _color => switch (widget.status) {
    BleConnectionStatus.connected => AppColors.success,
    BleConnectionStatus.scanning => AppColors.info,
    BleConnectionStatus.connecting => AppColors.amber,
    BleConnectionStatus.disconnected => AppColors.textDim,
    BleConnectionStatus.error => AppColors.error,
    BleConnectionStatus.lost => AppColors.error,
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _color.withValues(alpha: 0.4 + 0.6 * _animation.value),
          ),
        );
      },
    );
  }
}
