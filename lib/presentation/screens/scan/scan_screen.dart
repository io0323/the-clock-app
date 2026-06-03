import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/ble_connection_status.dart';
import '../../providers/ble_provider.dart';
import '../../widgets/scan/device_list_tile.dart';
import '../../widgets/scan/scan_animation_widget.dart';

final _isScanningProvider = StateProvider<bool>((ref) => false);
final _connectingDeviceIdProvider = StateProvider<String?>((ref) => null);

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScan();
    });
  }

  void _startScan() {
    ref.read(scannedDevicesProvider.notifier).startScan();
    ref.read(_isScanningProvider.notifier).state = true;
  }

  void _stopScan() {
    ref.read(scannedDevicesProvider.notifier).stopScan();
    ref.read(_isScanningProvider.notifier).state = false;
  }

  Future<void> _connectToDevice(String deviceId) async {
    ref.read(_connectingDeviceIdProvider.notifier).state = deviceId;
    _stopScan();

    final devices = ref.read(scannedDevicesProvider);
    final device = devices.firstWhere((d) => d.id == deviceId);

    try {
      await ref.read(connectDeviceUseCaseProvider).call(device);
      if (mounted) Navigator.of(context).pop();
    } on Exception {
      ref.read(_connectingDeviceIdProvider.notifier).state = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isScanning = ref.watch(_isScanningProvider);
    final devices = ref.watch(scannedDevicesProvider);
    final connectingId = ref.watch(_connectingDeviceIdProvider);

    ref.listen(bleConnectionStateProvider, (prev, next) {
      next.whenData((state) {
        if (state.status == BleConnectionStatus.connected && mounted) {
          Navigator.of(context).pop();
        }
      });
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('デバイスを探す', style: AppTextStyles.displayMedium),
                  const SizedBox(height: 4),
                  Text(
                    isScanning
                        ? 'BALMUDA_CLOCK を検索中...'
                        : '${devices.length} 台のデバイスが見つかりました',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(child: ScanAnimationWidget(isScanning: isScanning)),
            const SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  final device = devices[index];
                  return DeviceListTile(
                    device: device,
                    isConnecting: connectingId == device.id,
                    onTap: () => _connectToDevice(device.id),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: connectingId != null
                          ? null
                          : () {
                              if (isScanning) {
                                _stopScan();
                              } else {
                                _startScan();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.amber,
                        foregroundColor: AppColors.background,
                        disabledBackgroundColor: AppColors.surfaceVariant,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        isScanning ? 'スキャン停止' : 'スキャン開始',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: connectingId != null
                              ? AppColors.textDim
                              : AppColors.background,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'キャンセル',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textMuted,
                      ),
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
