import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../providers/mqtt_provider.dart';

class SensorCardWidget extends ConsumerWidget {
  const SensorCardWidget({super.key});

  static final _borderColor = AppColors.aluminiumDark.withValues(alpha: 0.2);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensorAsync = ref.watch(sensorDataProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: _borderColor, width: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: sensorAsync.when(
        data: (data) => _SensorRow(
          temperature: '${data.temperature.toStringAsFixed(1)}°',
          humidity: '${data.humidity}%',
        ),
        loading: () => const _ShimmerRow(),
        error: (_, __) => const _SensorRow(
          temperature: '--',
          humidity: '--',
        ),
      ),
    );
  }
}

class _SensorRow extends StatelessWidget {
  const _SensorRow({required this.temperature, required this.humidity});

  final String temperature;
  final String humidity;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SensorColumn(value: temperature, label: 'TEMP'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: VerticalDivider(
              width: 0.5,
              thickness: 0.5,
              color: AppColors.aluminiumDark.withValues(alpha: 0.2),
            ),
          ),
          _SensorColumn(value: humidity, label: 'HUM'),
        ],
      ),
    );
  }
}

class _SensorColumn extends StatelessWidget {
  const _SensorColumn({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.timeDisplay.copyWith(fontSize: 20),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textDim,
          ),
        ),
      ],
    );
  }
}

class _ShimmerRow extends StatefulWidget {
  const _ShimmerRow();

  @override
  State<_ShimmerRow> createState() => _ShimmerRowState();
}

class _ShimmerRowState extends State<_ShimmerRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final opacity = 0.15 + 0.15 * _controller.value;
        return IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ShimmerBlock(opacity: opacity),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: VerticalDivider(
                  width: 0.5,
                  thickness: 0.5,
                  color: AppColors.aluminiumDark.withValues(alpha: 0.2),
                ),
              ),
              _ShimmerBlock(opacity: opacity),
            ],
          ),
        );
      },
    );
  }
}

class _ShimmerBlock extends StatelessWidget {
  const _ShimmerBlock({required this.opacity});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.aluminiumDark.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 32,
          height: 10,
          decoration: BoxDecoration(
            color: AppColors.aluminiumDark.withValues(alpha: opacity * 0.6),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }
}
