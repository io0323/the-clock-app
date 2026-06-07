import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../providers/mqtt_provider.dart';

class MessageFeedWidget extends ConsumerWidget {
  const MessageFeedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(recentMqttMessagesProvider);

    if (messages.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'No messages received',
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.textDim),
        ),
      );
    }

    return AnimatedList(
      key: ValueKey(messages.length),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      initialItemCount: messages.length,
      itemBuilder: (context, index, animation) {
        final msg = messages[index];
        return SlideTransition(
          position: animation.drive(
            Tween(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOut)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        msg.topic,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.info,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm:ss').format(msg.receivedAt),
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textDim,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  msg.payload.toString(),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
