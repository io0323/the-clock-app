import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/ble_connection_status.dart';
import '../../providers/clock_provider.dart';
import 'connection_status_dot.dart';

class StatusBarWidget extends ConsumerWidget {
  const StatusBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleStatus = ref.watch(bleStatusProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatusItem(label: 'BLE', status: bleStatus),
        const _StatusItem(label: 'Wi-Fi', status: BleConnectionStatus.connected),
        const _StatusItem(label: 'MQTT', status: BleConnectionStatus.connecting),
      ],
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({required this.label, required this.status});

  final String label;
  final BleConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConnectionStatusDot(status: status),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
