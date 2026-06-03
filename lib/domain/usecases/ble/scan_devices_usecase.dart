import 'dart:async';

import '../../entities/ble_device.dart';
import '../../repositories/ble_repository.dart';

class ScanDevicesUseCase {
  const ScanDevicesUseCase(this._repository);

  final BleRepository _repository;

  static const int _minRssi = -90;

  Stream<BleDevice> call({
    Duration timeout = const Duration(seconds: 30),
    String nameFilter = BleRepository.deviceNamePrefix,
  }) {
    final seenIds = <String>{};

    return _repository
        .scanDevices(timeout: timeout, nameFilter: nameFilter)
        .where((device) => device.rssi >= _minRssi)
        .where((device) => seenIds.add(device.id));
  }
}
