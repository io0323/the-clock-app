import '../entities/ble_connection_state.dart';
import '../entities/ble_device.dart';

abstract class BleRepository {
  Stream<BleDevice> scanDevices({
    Duration timeout = const Duration(seconds: 30),
    String? nameFilter,
  });

  Future<void> connect(
    BleDevice device, {
    Duration timeout = const Duration(seconds: 10),
  });

  Future<void> disconnect();

  Stream<BleConnectionState> watchConnectionState();

  Future<int> readRssi();

  static const String deviceNamePrefix = 'io0323_CLOCK';
}
