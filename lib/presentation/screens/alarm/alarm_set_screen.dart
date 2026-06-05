import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/errors/mqtt_exception.dart';
import '../../providers/mqtt_provider.dart';
import 'widgets/sound_selector_widget.dart';
import 'widgets/time_picker_widget.dart';
import 'widgets/volume_slider_widget.dart';

class AlarmSetScreen extends ConsumerStatefulWidget {
  const AlarmSetScreen({super.key});

  @override
  ConsumerState<AlarmSetScreen> createState() => _AlarmSetScreenState();
}

class _AlarmSetScreenState extends ConsumerState<AlarmSetScreen> {
  bool _isSending = false;

  Future<void> _submit() async {
    setState(() => _isSending = true);

    final hour = ref.read(selectedHourProvider);
    final minute = ref.read(selectedMinuteProvider);
    final sound = ref.read(selectedSoundProvider);
    final volume = ref.read(selectedVolumeProvider);
    final time =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

    try {
      await ref.read(publishAlarmUseCaseProvider).call(
            deviceId: 'default',
            time: time,
            sound: sound,
            volume: volume / 100.0,
          );
      ref.invalidate(deviceShadowProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('アラームを設定しました')),
      );
      Navigator.of(context).pop();
    } on MqttSpecificException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.userMessage)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('送信に失敗しました')),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text('アラーム設定', style: AppTextStyles.displayMedium),
            const SizedBox(height: 32),
            const TimePickerWidget(),
            const SizedBox(height: 24),
            const SoundSelectorWidget(),
            const SizedBox(height: 24),
            const VolumeSliderWidget(),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _isSending
                          ? null
                          : () => Navigator.of(context).pop(),
                      child: Text(
                        'キャンセル',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: AppColors.textMuted),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSending ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.amber,
                        foregroundColor: AppColors.background,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isSending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.background,
                              ),
                            )
                          : Text('設定を送信',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.background,
                                fontWeight: FontWeight.w500,
                              )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
