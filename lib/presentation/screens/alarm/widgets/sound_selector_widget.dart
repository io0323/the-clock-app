import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

final selectedSoundProvider = StateProvider<String>((ref) => 'chime');

const _sounds = <String, String>{
  'rain': '🌧',
  'chime': '🔔',
  'piano': '🎹',
  'forest': '🌲',
  'waves': '🌊',
};

class SoundSelectorWidget extends ConsumerWidget {
  const SoundSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedSoundProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text('サウンド', style: AppTextStyles.labelSmall),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _sounds.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final entry = _sounds.entries.elementAt(index);
              final isSelected = entry.key == selected;
              return GestureDetector(
                onTap: () =>
                    ref.read(selectedSoundProvider.notifier).state = entry.key,
                child: Container(
                  width: 72,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.amber
                          : AppColors.surfaceVariant,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(entry.value, style: const TextStyle(fontSize: 24)),
                      const SizedBox(height: 4),
                      if (isSelected)
                        Text(
                          entry.key,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.amber,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
