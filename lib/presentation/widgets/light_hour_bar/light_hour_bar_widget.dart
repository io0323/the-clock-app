import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_clock_app/core/constants/app_colors.dart';
import 'package:the_clock_app/presentation/providers/clock_provider.dart';

class LightHourBarWidget extends ConsumerWidget {
  const LightHourBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(lightHourProgressProvider);

    return SizedBox(
      width: double.infinity,
      height: 4,
      child: Stack(
        children: [
          Container(color: AppColors.surfaceVariant),
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.linear,
            width: MediaQuery.of(context).size.width * progress.clamp(0.0, 1.0),
            height: 4,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.amberDim, AppColors.amber],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
