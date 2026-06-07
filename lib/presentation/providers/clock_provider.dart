import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/ble_connection_status.dart';
import '../../domain/entities/clock_state.dart';
import '../../domain/repositories/clock_repository.dart';

final clockRepositoryProvider = Provider<ClockRepository>((ref) {
  throw UnimplementedError('clockRepositoryProvider must be overridden');
});

final clockStateProvider = StreamProvider<ClockState>((ref) {
  final repository = ref.watch(clockRepositoryProvider);
  return repository.watchClockState();
});

final currentTimeProvider = Provider<DateTime>((ref) {
  return ref
          .watch(clockStateProvider)
          .whenOrNull(data: (state) => state.currentTime) ??
      DateTime.now();
});

final lightHourProgressProvider = Provider<double>((ref) {
  return ref
          .watch(clockStateProvider)
          .whenOrNull(data: (state) => state.lightHourProgress) ??
      0.0;
});

final bleStatusProvider = Provider<BleConnectionStatus>((ref) {
  return ref
          .watch(clockStateProvider)
          .whenOrNull(data: (state) => state.bleStatus) ??
      BleConnectionStatus.disconnected;
});
