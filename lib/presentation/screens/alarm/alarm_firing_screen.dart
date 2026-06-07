import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/alarm_trigger_event.dart';

class AlarmFiringScreen extends ConsumerWidget {
  const AlarmFiringScreen({super.key, required this.event});

  final AlarmTriggerEvent event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeStr =
        '${event.triggeredAt.hour.toString().padLeft(2, '0')}:${event.triggeredAt.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            _PulseRing(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.amber, width: 2),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeStr,
                      style: AppTextStyles.timeDisplay.copyWith(
                        fontSize: 40,
                        color: AppColors.amber,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event.sound.label,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.amberSoft,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
            Text(
                  'アラーム',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: AppColors.amber,
                  ),
                )
                .animate(onPlay: (c) => c.repeat())
                .fadeIn(duration: 1200.ms)
                .then()
                .fadeOut(duration: 1200.ms),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      label: 'スヌーズ',
                      icon: Icons.snooze,
                      color: AppColors.surfaceVariant,
                      textColor: AppColors.textPrimary,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ActionButton(
                      label: '停止',
                      icon: Icons.alarm_off,
                      color: AppColors.amber,
                      textColor: AppColors.background,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _PulseRing extends StatelessWidget {
  const _PulseRing({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.amberDim, width: 1),
              ),
            )
            .animate(onPlay: (c) => c.repeat())
            .scaleXY(begin: 0.9, end: 1.1, duration: 1500.ms)
            .fadeOut(begin: 0.6, duration: 1500.ms),
        Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.amberDim, width: 0.5),
              ),
            )
            .animate(onPlay: (c) => c.repeat())
            .scaleXY(begin: 0.85, end: 1.15, duration: 2000.ms)
            .fadeOut(begin: 0.4, duration: 2000.ms),
        child,
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
