import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/demo_data.dart';
import '../../../domain/entities/alarm_config.dart';
import 'alarm_set_screen.dart';

final alarmListProvider = StateProvider<List<AlarmConfig>>(
  (ref) => DemoData.alarms,
);

class AlarmListScreen extends ConsumerWidget {
  const AlarmListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarms = ref.watch(alarmListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('アラーム', style: AppTextStyles.displayMedium),
                      const SizedBox(height: 4),
                      Text(
                        '${alarms.where((a) => a.active).length} 件が有効',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const AlarmSetScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, color: AppColors.amber),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: alarms.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _AlarmCard(alarm: alarms[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  '戻る',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlarmCard extends ConsumerWidget {
  const _AlarmCard({required this.alarm});

  final AlarmConfig alarm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: alarm.active ? AppColors.amberDim : AppColors.surfaceVariant,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      alarm.time,
                      style: AppTextStyles.timeDisplay.copyWith(
                        fontSize: 28,
                        color: alarm.active
                            ? AppColors.amber
                            : AppColors.textDim,
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (alarm.label != null)
                      Text(
                        alarm.label!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _WeekdayIndicator(alarm: alarm),
                    const SizedBox(width: 12),
                    Icon(Icons.music_note, size: 14, color: AppColors.textDim),
                    const SizedBox(width: 4),
                    Text(alarm.sound.label, style: AppTextStyles.labelSmall),
                    if (alarm.snoozeEnabled) ...[
                      const SizedBox(width: 12),
                      Icon(Icons.snooze, size: 14, color: AppColors.textDim),
                      const SizedBox(width: 4),
                      Text(
                        '${alarm.snoozeMinutes}分',
                        style: AppTextStyles.labelSmall,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Switch(
            value: alarm.active,
            activeThumbColor: AppColors.amber,
            activeTrackColor: AppColors.amberDim,
            inactiveThumbColor: AppColors.textDim,
            inactiveTrackColor: AppColors.surfaceVariant,
            onChanged: (value) {
              final alarms = ref.read(alarmListProvider);
              final updated = alarms.map((a) {
                if (a.id == alarm.id) return a.copyWith(active: value);
                return a;
              }).toList();
              ref.read(alarmListProvider.notifier).state = updated;
            },
          ),
        ],
      ),
    );
  }
}

class _WeekdayIndicator extends StatelessWidget {
  const _WeekdayIndicator({required this.alarm});

  final AlarmConfig alarm;

  @override
  Widget build(BuildContext context) {
    if (alarm.weekdays.isEmpty) {
      return Text('1回のみ', style: AppTextStyles.labelSmall);
    }
    return Row(
      children: alarm.weekdays.map((day) {
        return Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Text(
            day.label,
            style: AppTextStyles.labelSmall.copyWith(
              color: alarm.active ? AppColors.amberSoft : AppColors.textDim,
            ),
          ),
        );
      }).toList(),
    );
  }
}
