import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/entities/ble_device.dart';

class DeviceListTile extends StatelessWidget {
  const DeviceListTile({
    super.key,
    required this.device,
    required this.onTap,
    this.isConnecting = false,
  });

  final BleDevice device;
  final VoidCallback onTap;
  final bool isConnecting;

  @override
  Widget build(BuildContext context) {
    final rssiNormalized = ((device.rssi + 100) / 60).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: isConnecting ? null : onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.surfaceVariant),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.name.isEmpty ? 'Unknown Device' : device.name,
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    device.id,
                    style: GoogleFonts.dmMono(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _RssiBar(value: rssiNormalized, rssi: device.rssi),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (isConnecting)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: AppColors.amber,
                ),
              )
            else
              const Icon(
                Icons.chevron_right,
                color: AppColors.textDim,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class _RssiBar extends StatelessWidget {
  const _RssiBar({required this.value, required this.rssi});

  final double value;
  final int rssi;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          height: 3,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1.5),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: AppColors.surfaceVariant,
              color: value > 0.6
                  ? AppColors.success
                  : value > 0.3
                      ? AppColors.warning
                      : AppColors.error,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$rssi dBm',
          style: GoogleFonts.dmMono(
            fontSize: 9,
            color: AppColors.textDim,
          ),
        ),
      ],
    );
  }
}
