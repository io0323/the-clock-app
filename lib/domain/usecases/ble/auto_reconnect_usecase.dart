import 'dart:async';
import 'dart:math';

import '../../entities/ble_connection_state.dart';
import '../../entities/ble_connection_status.dart';
import '../../entities/ble_device.dart';
import '../../repositories/ble_repository.dart';

class AutoReconnectUseCase {
  AutoReconnectUseCase(this._repository);

  final BleRepository _repository;

  static const int maxRetries = 5;
  static const Duration _maxBackoff = Duration(seconds: 30);

  StreamSubscription<BleConnectionState>? _subscription;
  bool _cancelled = false;

  void start(BleDevice device) {
    _cancelled = false;
    _subscription = _repository.watchConnectionState().listen((state) {
      if (_cancelled) return;

      if (state.status == BleConnectionStatus.error ||
          state.status == BleConnectionStatus.lost) {
        _attemptReconnect(device, retryCount: 0);
      }
    });
  }

  Future<void> _attemptReconnect(
    BleDevice device, {
    required int retryCount,
  }) async {
    if (_cancelled || retryCount >= maxRetries) {
      return;
    }

    final backoff = Duration(
      seconds: min(pow(2, retryCount).toInt(), _maxBackoff.inSeconds),
    );

    await Future<void>.delayed(backoff);

    if (_cancelled) return;

    try {
      await _repository.connect(device);
    } on Exception {
      if (!_cancelled) {
        await _attemptReconnect(device, retryCount: retryCount + 1);
      }
    }
  }

  void cancel() {
    _cancelled = true;
    _subscription?.cancel();
    _subscription = null;
  }
}
