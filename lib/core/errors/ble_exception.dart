import 'app_exception.dart';

sealed class BleSpecificException extends BleException {
  const BleSpecificException(super.message, {super.code});

  String get userMessage;
}

class BlePermissionException extends BleSpecificException {
  const BlePermissionException({String? message})
    : super(
        message ?? 'Bluetooth permission not granted',
        code: 'BLE_PERMISSION',
      );

  @override
  String get userMessage => 'Bluetoothの権限が許可されていません。設定から許可してください。';
}

class BleAdapterOffException extends BleSpecificException {
  const BleAdapterOffException({String? message})
    : super(message ?? 'Bluetooth adapter is off', code: 'BLE_ADAPTER_OFF');

  @override
  String get userMessage => 'Bluetoothがオフになっています。オンにしてください。';
}

class BleDeviceNotFoundException extends BleSpecificException {
  const BleDeviceNotFoundException({String? message})
    : super(message ?? 'Device not found', code: 'BLE_DEVICE_NOT_FOUND');

  @override
  String get userMessage => 'デバイスが見つかりませんでした。電源が入っているか確認してください。';
}

class BleConnectionTimeoutException extends BleSpecificException {
  const BleConnectionTimeoutException({this.timeoutSec = 10, String? message})
    : super(message ?? 'Connection timed out', code: 'BLE_TIMEOUT');

  final int timeoutSec;

  @override
  String get userMessage => '接続がタイムアウトしました（$timeoutSec秒）。再試行してください。';
}

class BleConnectionLostException extends BleSpecificException {
  const BleConnectionLostException({this.wasConnected = true, String? message})
    : super(message ?? 'Connection lost', code: 'BLE_CONNECTION_LOST');

  final bool wasConnected;

  @override
  String get userMessage => 'デバイスとの接続が切断されました。';
}

class BleAuthException extends BleSpecificException {
  const BleAuthException({String? message})
    : super(message ?? 'Authentication failed', code: 'BLE_AUTH');

  @override
  String get userMessage => 'デバイスの認証に失敗しました。';
}

class BleUnknownException extends BleSpecificException {
  const BleUnknownException({this.cause, String? message})
    : super(message ?? 'Unknown BLE error', code: 'BLE_UNKNOWN');

  final Object? cause;

  @override
  String get userMessage => '予期しないエラーが発生しました。アプリを再起動してください。';
}
