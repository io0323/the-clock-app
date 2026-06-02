import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../providers/clock_provider.dart';
import '../../widgets/clock_face/clock_face_widget.dart';
import '../../widgets/light_hour_bar/light_hour_bar_widget.dart';
import '../../widgets/status_bar/status_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Text(
              'The Clock',
              style: AppTextStyles.displayMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              'BALMUDA Connect',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            const ClockFaceWidget(),
            const SizedBox(height: 16),
            const LightHourBarWidget(),
            const SizedBox(height: 8),
            const _TimeTextWidget(),
            const SizedBox(height: 32),
            const StatusBarWidget(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _TimeTextWidget extends ConsumerWidget {
  const _TimeTextWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTime = ref.watch(currentTimeProvider);
    final timeString = DateFormat('HH:mm').format(currentTime);
    final dateString = DateFormat('EEE, MMM d').format(currentTime);

    return Column(
      children: [
        Center(
          child: Text(
            timeString,
            style: AppTextStyles.timeDisplay.copyWith(
              color: AppColors.amber,
            ),
          ),
        ),
        Center(
          child: Text(
            dateString,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
