import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

final selectedVolumeProvider = StateProvider<double>((ref) => 50);

class VolumeSliderWidget extends ConsumerWidget {
  const VolumeSliderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volume = ref.watch(selectedVolumeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ボリューム', style: AppTextStyles.labelSmall),
              Text(
                '${volume.round()}%',
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.amber,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.amber,
              inactiveTrackColor: AppColors.surfaceVariant,
              thumbColor: AppColors.amberSoft,
              overlayColor: AppColors.amber.withAlpha(30),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: volume,
              min: 0,
              max: 100,
              divisions: 10,
              onChanged: (v) =>
                  ref.read(selectedVolumeProvider.notifier).state = v,
            ),
          ),
        ],
      ),
    );
  }
}
