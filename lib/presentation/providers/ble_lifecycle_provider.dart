import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/ble_logger.dart';
import '../../domain/entities/ble_connection_status.dart';
import 'ble_provider.dart';

final bleLifecycleProvider = Provider<BleLifecycleObserver>((ref) {
  final observer = BleLifecycleObserver(ref);
  WidgetsBinding.instance.addObserver(observer);
  ref.onDispose(() {
    WidgetsBinding.instance.removeObserver(observer);
    observer.dispose();
  });
  return observer;
});

class BleLifecycleObserver with WidgetsBindingObserver {
  BleLifecycleObserver(this._ref);

  final Ref _ref;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _onResumed();
      case AppLifecycleState.paused:
        _onPaused();
      default:
        break;
    }
  }

  void _onResumed() {
    BleLogger.lifecycleResumed();

    final bleState = _ref.read(bleConnectionStateProvider).valueOrNull;
    if (bleState == null) return;

    final status = bleState.status;
    final device = bleState.connectedDevice;

    if (device != null &&
        (status == BleConnectionStatus.disconnected ||
            status == BleConnectionStatus.error ||
            status == BleConnectionStatus.lost)) {
      _ref.read(autoReconnectUseCaseProvider).start(device);
    }
  }

  void _onPaused() {
    BleLogger.lifecyclePaused();
    _ref.read(scannedDevicesProvider.notifier).stopScan();
  }

  void dispose() {
    _ref.read(autoReconnectUseCaseProvider).cancel();
  }
}
