import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../domain/repositories/mqtt_repository.dart';
import '../../providers/mqtt_provider.dart';

class MqttStatusWidget extends ConsumerWidget {
  const MqttStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusAsync = ref.watch(mqttConnectionStatusProvider);
    final status = statusAsync.valueOrNull ?? MqttConnectionStatus.disconnected;

    return GestureDetector(
      onTap: status == MqttConnectionStatus.error
          ? () async {
              try {
                await ref.read(connectMqttUseCaseProvider).call();
              } on Exception {
                // handled by status stream
              }
            }
          : null,
      child: _MqttDot(status: status),
    );
  }
}

class _MqttDot extends StatefulWidget {
  const _MqttDot({required this.status});

  final MqttConnectionStatus status;

  @override
  State<_MqttDot> createState() => _MqttDotState();
}

class _MqttDotState extends State<_MqttDot>
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
  void didUpdateWidget(_MqttDot oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.status != widget.status) {
      _controller.stop();
      _configureAnimation();
    }
  }

  void _configureAnimation() {
    switch (widget.status) {
      case MqttConnectionStatus.connected:
        _controller.duration = const Duration(milliseconds: 2000);
        _animation = CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        );
        _controller.repeat(reverse: true);
      case MqttConnectionStatus.connecting:
      case MqttConnectionStatus.reconnecting:
        _controller.duration = const Duration(milliseconds: 800);
        _animation = CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        );
        _controller.repeat(reverse: true);
      case MqttConnectionStatus.error:
        _controller.duration = const Duration(milliseconds: 600);
        _animation = CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        );
        _controller.repeat(reverse: true);
      case MqttConnectionStatus.disconnected:
        _animation = const AlwaysStoppedAnimation(1.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _color => switch (widget.status) {
    MqttConnectionStatus.connected => AppColors.success,
    MqttConnectionStatus.connecting => AppColors.amber,
    MqttConnectionStatus.reconnecting => AppColors.amber,
    MqttConnectionStatus.error => AppColors.error,
    MqttConnectionStatus.disconnected => AppColors.textDim,
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
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
