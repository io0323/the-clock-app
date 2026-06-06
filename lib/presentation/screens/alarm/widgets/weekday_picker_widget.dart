import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../domain/entities/alarm_weekday.dart';

class WeekdayPickerWidget extends StatelessWidget {
  const WeekdayPickerWidget({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final List<AlarmWeekday> selected;
  final ValueChanged<List<AlarmWeekday>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: AlarmWeekday.values.map((day) {
          final isSelected = selected.contains(day);
          return GestureDetector(
            onTap: () {
              final updated = List<AlarmWeekday>.from(selected);
              if (isSelected) {
                updated.remove(day);
              } else {
                updated.add(day);
              }
              onChanged(updated);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.amber : AppColors.surfaceVariant,
                border: Border.all(
                  color: isSelected ? AppColors.amber : AppColors.textDim,
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                day.label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? AppColors.background : AppColors.textMuted,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w300,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
