import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/errors/ble_exception.dart';
import '../../domain/entities/ble_connection_status.dart';
import '../../domain/entities/ble_device.dart';

class BleDataSource {
  BluetoothDevice? _connectedDevice;

  bool get isConnected => _connectedDevice?.isConnected ?? false;

  // iOS ではバックグラウンドスキャンには withServices の指定が必要。
  // 現状フォアグラウンドのみ対応のため省略している。
  Stream<BleDevice> scan({
    Duration timeout = const Duration(seconds: 30),
    String? nameFilter,
  }) {
    final controller = StreamController<BleDevice>();

    () async {
      try {
        if (FlutterBluePlus.isScanningNow) {
          await FlutterBluePlus.stopScan();
        }

        final subscription = FlutterBluePlus.onScanResults.listen((results) {
          for (final r in results) {
            if (nameFilter != null &&
                !r.advertisementData.advName.startsWith(nameFilter)) {
              continue;
            }
            controller.add(_toDevice(r));
          }
        }, onError: (Object e) => controller.addError(_wrapException(e)));

        FlutterBluePlus.cancelWhenScanComplete(subscription);

        await FlutterBluePlus.startScan(
          withNames: nameFilter != null ? [nameFilter] : [],
          timeout: timeout,
        );

        await FlutterBluePlus.isScanning.where((val) => val == false).first;

        await controller.close();
      } on Exception catch (e) {
        controller.addError(_wrapException(e));
        await controller.close();
      }
    }();

    return controller.stream;
  }

  Future<void> connect(
    String deviceId, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    try {
      final device = BluetoothDevice.fromId(deviceId);
      await device.connect(timeout: timeout);
      _connectedDevice = device;
    } on FlutterBluePlusException catch (e) {
      throw _wrapException(e);
    } on TimeoutException {
      throw BleConnectionTimeoutException(timeoutSec: timeout.inSeconds);
    } on Exception catch (e) {
      throw _wrapException(e);
    }
  }

  Future<void> disconnect(String deviceId) async {
    try {
      final device = BluetoothDevice.fromId(deviceId);
      await device.disconnect();
      _connectedDevice = null;
    } on Exception catch (e) {
      throw _wrapException(e);
    }
  }

  Stream<BleConnectionStatus> watchStatus(String deviceId) {
    final device = BluetoothDevice.fromId(deviceId);
    return device.connectionState.map(
      (state) => switch (state) {
        BluetoothConnectionState.connected => BleConnectionStatus.connected,
        BluetoothConnectionState.disconnected =>
          BleConnectionStatus.disconnected,
        _ => BleConnectionStatus.connecting,
      },
    );
  }

  Future<int> readRssi(String deviceId) async {
    try {
      final device = BluetoothDevice.fromId(deviceId);
      return await device.readRssi();
    } on Exception catch (e) {
      throw _wrapException(e);
    }
  }

  Future<bool> isBluetoothOn() async {
    try {
      final state = await FlutterBluePlus.adapterState.first;
      return state == BluetoothAdapterState.on;
    } on Exception {
      return false;
    }
  }

  // Android 12+ では BLUETOOTH_SCAN / BLUETOOTH_CONNECT が必要。
  // iOS では Info.plist の NSBluetoothAlwaysUsageDescription で対応。
  Future<bool> requestPermissions() async {
    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    return statuses.values.every(
      (status) => status.isGranted || status.isLimited,
    );
  }

  BleDevice _toDevice(ScanResult result) {
    return BleDevice(
      id: result.device.remoteId.str,
      name: result.advertisementData.advName,
      rssi: result.rssi,
      isConnectable: result.advertisementData.connectable,
      discoveredAt: DateTime.now(),
    );
  }

  BleSpecificException _wrapException(Object e) {
    if (e is BleSpecificException) return e;

    final message = e.toString();

    if (message.contains('permission')) {
      return const BlePermissionException();
    }
    if (message.contains('timeout')) {
      return const BleConnectionTimeoutException();
    }
    if (message.contains('adapter') || message.contains('off')) {
      return const BleAdapterOffException();
    }

    return BleUnknownException(cause: e, message: message);
  }
}
