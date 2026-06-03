import 'package:logger/logger.dart';

import '../../entities/ble_connection_status.dart';
import '../../entities/ble_device.dart';
import '../../repositories/ble_repository.dart';

class ConnectDeviceUseCase {
  ConnectDeviceUseCase(this._repository);

  final BleRepository _repository;
  final _logger = Logger();

  Future<void> call(
    BleDevice device, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    final currentState = await _repository.watchConnectionState().first;

    if (currentState.status == BleConnectionStatus.connecting) {
      return;
    }

    if (currentState.status == BleConnectionStatus.scanning) {
      throw StateError('Stop scanning before connecting');
    }

    await _repository.connect(device, timeout: timeout);

    try {
      final rssi = await _repository.readRssi();
      _logger.d('Connected to ${device.name}, RSSI: $rssi dBm');
    } on Exception catch (e) {
      _logger.w('Failed to read RSSI after connect: $e');
    }
  }
}
