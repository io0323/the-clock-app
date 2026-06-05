import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

final selectedHourProvider = StateProvider<int>((ref) => 7);
final selectedMinuteProvider = StateProvider<int>((ref) => 0);

class TimePickerWidget extends ConsumerWidget {
  const TimePickerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 160,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _DrumRoll(
            itemCount: 24,
            selectedIndex: ref.watch(selectedHourProvider),
            onChanged: (v) => ref.read(selectedHourProvider.notifier).state = v,
            label: '時',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(':', style: AppTextStyles.timeDisplay.copyWith(color: AppColors.amber)),
          ),
          _DrumRoll(
            itemCount: 60,
            selectedIndex: ref.watch(selectedMinuteProvider),
            onChanged: (v) => ref.read(selectedMinuteProvider.notifier).state = v,
            label: '分',
          ),
        ],
      ),
    );
  }
}

class _DrumRoll extends StatefulWidget {
  const _DrumRoll({
    required this.itemCount,
    required this.selectedIndex,
    required this.onChanged,
    required this.label,
  });

  final int itemCount;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final String label;

  @override
  State<_DrumRoll> createState() => _DrumRollState();
}

class _DrumRollState extends State<_DrumRoll> {
  late final FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: widget.selectedIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.label, style: AppTextStyles.labelSmall),
        const SizedBox(height: 4),
        SizedBox(
          width: 72,
          height: 120,
          child: ListWheelScrollView.useDelegate(
            controller: _controller,
            itemExtent: 40,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: widget.onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: widget.itemCount,
              builder: (context, index) {
                final isSelected = index == widget.selectedIndex;
                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: AppTextStyles.timeDisplay.copyWith(
                      fontSize: isSelected ? 28 : 20,
                      color: isSelected ? AppColors.amber : AppColors.textDim,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
