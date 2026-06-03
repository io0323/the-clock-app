import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/ble_datasource.dart';
import '../../data/repositories/ble_repository_impl.dart';
import '../../domain/entities/ble_connection_state.dart';
import '../../domain/entities/ble_device.dart';
import '../../domain/repositories/ble_repository.dart';
import '../../domain/usecases/ble/auto_reconnect_usecase.dart';
import '../../domain/usecases/ble/connect_device_usecase.dart';
import '../../domain/usecases/ble/scan_devices_usecase.dart';

final bleDataSourceProvider = Provider<BleDataSource>((ref) {
  return BleDataSource();
});

final bleRepositoryProvider = Provider<BleRepository>((ref) {
  return BleRepositoryImpl(ref.watch(bleDataSourceProvider));
});

final scanDevicesUseCaseProvider = Provider<ScanDevicesUseCase>((ref) {
  return ScanDevicesUseCase(ref.watch(bleRepositoryProvider));
});

final connectDeviceUseCaseProvider = Provider<ConnectDeviceUseCase>((ref) {
  return ConnectDeviceUseCase(ref.watch(bleRepositoryProvider));
});

final autoReconnectUseCaseProvider = Provider<AutoReconnectUseCase>((ref) {
  return AutoReconnectUseCase(ref.watch(bleRepositoryProvider));
});

final bleConnectionStateProvider =
    StreamProvider<BleConnectionState>((ref) {
  final repository = ref.watch(bleRepositoryProvider);
  return repository.watchConnectionState();
});

final scannedDevicesProvider =
    StateNotifierProvider<ScannedDevicesNotifier, List<BleDevice>>((ref) {
  return ScannedDevicesNotifier(ref.watch(scanDevicesUseCaseProvider));
});

class ScannedDevicesNotifier extends StateNotifier<List<BleDevice>> {
  ScannedDevicesNotifier(this._scanUseCase) : super(const []);

  final ScanDevicesUseCase _scanUseCase;
  StreamSubscription<BleDevice>? _subscription;

  void startScan() {
    state = const [];
    _subscription?.cancel();
    _subscription = _scanUseCase.call().listen(
      (device) {
        final index = state.indexWhere((d) => d.id == device.id);
        if (index >= 0) {
          state = [...state]..[index] = device;
        } else {
          state = [...state, device];
        }
      },
      onDone: () => _subscription = null,
    );
  }

  void stopScan() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
