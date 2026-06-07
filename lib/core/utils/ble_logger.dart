import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../../domain/entities/ble_device.dart';

final _logger = Logger(
  printer: PrettyPrinter(methodCount: 0, printEmojis: false),
);

String _time() {
  final now = DateTime.now();
  return '${now.hour.toString().padLeft(2, '0')}:'
      '${now.minute.toString().padLeft(2, '0')}:'
      '${now.second.toString().padLeft(2, '0')}';
}

abstract final class BleLogger {
  static void scanStart({String? filter}) {
    if (!kDebugMode) return;
    _logger.d('[BLE][${_time()}] SCAN_START filter=$filter');
  }

  static void scanStop() {
    if (!kDebugMode) return;
    _logger.d('[BLE][${_time()}] SCAN_STOP');
  }

  static void deviceFound(BleDevice device) {
    if (!kDebugMode) return;
    _logger.d(
      '[BLE][${_time()}] DEVICE_FOUND '
      'id=${device.id} name=${device.name} rssi=${device.rssi}',
    );
  }

  static void connectStart(BleDevice device, {int timeoutSec = 10}) {
    if (!kDebugMode) return;
    _logger.d(
      '[BLE][${_time()}] CONNECT_START '
      'device=${device.name} timeout=${timeoutSec}s',
    );
  }

  static void connectOk({required int rssi, required Duration elapsed}) {
    if (!kDebugMode) return;
    final sec = (elapsed.inMilliseconds / 1000).toStringAsFixed(1);
    _logger.i('[BLE][${_time()}] CONNECT_OK rssi=$rssi elapsed=${sec}s');
  }

  static void connectFailed(Object error) {
    if (!kDebugMode) return;
    _logger.e('[BLE][${_time()}] CONNECT_FAILED error=$error');
  }

  static void disconnectDetected({
    required int attempt,
    required int maxAttempts,
    required Duration retryIn,
  }) {
    if (!kDebugMode) return;
    _logger.w(
      '[BLE][${_time()}] DISCONNECT_DETECTED '
      'retrying in=${retryIn.inSeconds}s attempt=$attempt/$maxAttempts',
    );
  }

  static void reconnectOk({required int attempt}) {
    if (!kDebugMode) return;
    _logger.i('[BLE][${_time()}] RECONNECT_OK attempt=$attempt');
  }

  static void reconnectFailed({required int attempt, required Object error}) {
    if (!kDebugMode) return;
    _logger.e(
      '[BLE][${_time()}] RECONNECT_FAILED '
      'attempt=$attempt error=$error',
    );
  }

  static void lifecycleResumed() {
    if (!kDebugMode) return;
    _logger.d('[BLE][${_time()}] LIFECYCLE_RESUMED');
  }

  static void lifecyclePaused() {
    if (!kDebugMode) return;
    _logger.d('[BLE][${_time()}] LIFECYCLE_PAUSED');
  }
}
