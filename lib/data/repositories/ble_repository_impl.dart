import 'dart:async';

import '../../core/errors/ble_exception.dart';
import '../../domain/entities/ble_connection_state.dart';
import '../../domain/entities/ble_connection_status.dart';
import '../../domain/entities/ble_device.dart';
import '../../domain/repositories/ble_repository.dart';
import '../datasources/ble_datasource.dart';

class BleRepositoryImpl implements BleRepository {
  BleRepositoryImpl(this._dataSource);

  final BleDataSource _dataSource;
  BleDevice? _connectedDevice;

  @override
  Stream<BleDevice> scanDevices({
    Duration timeout = const Duration(seconds: 30),
    String? nameFilter,
  }) {
    return _dataSource.scan(
      timeout: timeout,
      nameFilter: nameFilter ?? BleRepository.deviceNamePrefix,
    );
  }

  @override
  Future<void> connect(
    BleDevice device, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (!await _dataSource.isBluetoothOn()) {
      throw const BleAdapterOffException();
    }

    if (!await _dataSource.requestPermissions()) {
      throw const BlePermissionException();
    }

    await _dataSource.connect(device.id, timeout: timeout);
    _connectedDevice = device;
  }

  @override
  Future<void> disconnect() async {
    final device = _connectedDevice;
    if (device == null) return;

    await _dataSource.disconnect(device.id);
    _connectedDevice = null;
  }

  @override
  Stream<BleConnectionState> watchConnectionState() {
    final device = _connectedDevice;
    if (device == null) {
      return Stream.value(BleConnectionState.initial);
    }

    return _dataSource.watchStatus(device.id).map((status) {
      return BleConnectionState(
        status: status,
        connectedDevice: status == BleConnectionStatus.connected
            ? device
            : null,
        connectedAt: status == BleConnectionStatus.connected
            ? DateTime.now()
            : null,
      );
    });
  }

  @override
  Future<int> readRssi() async {
    final device = _connectedDevice;
    if (device == null) {
      throw const BleDeviceNotFoundException(message: 'No device connected');
    }

    return _dataSource.readRssi(device.id);
  }
}
