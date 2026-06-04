import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/ble_connection_status.dart';
import '../../providers/ble_provider.dart';
import '../../screens/scan/scan_screen.dart';
import '../mqtt/mqtt_status_widget.dart';
import 'connection_status_dot.dart';

class StatusBarWidget extends ConsumerWidget {
  const StatusBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bleState = ref.watch(bleConnectionStateProvider);
    final bleStatus = bleState.whenOrNull(data: (s) => s.status)
        ?? BleConnectionStatus.disconnected;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ScanScreen(),
              ),
            );
          },
          child: _StatusItem(label: 'BLE', child: ConnectionStatusDot(status: bleStatus)),
        ),
        _StatusItem(
          label: 'Wi-Fi',
          child: ConnectionStatusDot(status: BleConnectionStatus.connected),
        ),
        const _StatusItem(label: 'MQTT', child: MqttStatusWidget()),
      ],
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
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
