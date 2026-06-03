import 'ble_connection_status.dart';
import 'ble_device.dart';

class BleConnectionState {
  const BleConnectionState({
    required this.status,
    this.connectedDevice,
    this.retryCount = 0,
    this.errorMessage,
    this.connectedAt,
    this.rssi,
  });

  final BleConnectionStatus status;
  final BleDevice? connectedDevice;
  final int retryCount;
  final String? errorMessage;
  final DateTime? connectedAt;
  final int? rssi;

  static const initial = BleConnectionState(
    status: BleConnectionStatus.disconnected,
  );

  bool get isConnected => status == BleConnectionStatus.connected;
  bool get hasError => status == BleConnectionStatus.error;

  BleConnectionState copyWith({
    BleConnectionStatus? status,
    BleDevice? connectedDevice,
    bool clearDevice = false,
    int? retryCount,
    String? errorMessage,
    bool clearError = false,
    DateTime? connectedAt,
    bool clearConnectedAt = false,
    int? rssi,
    bool clearRssi = false,
  }) {
    return BleConnectionState(
      status: status ?? this.status,
      connectedDevice:
          clearDevice ? null : (connectedDevice ?? this.connectedDevice),
      retryCount: retryCount ?? this.retryCount,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      connectedAt:
          clearConnectedAt ? null : (connectedAt ?? this.connectedAt),
      rssi: clearRssi ? null : (rssi ?? this.rssi),
    );
  }

  @override
  String toString() =>
      'BleConnectionState(status: $status, device: $connectedDevice, retryCount: $retryCount)';
}
