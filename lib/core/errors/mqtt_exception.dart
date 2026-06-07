import 'app_exception.dart';

sealed class MqttSpecificException extends MqttException {
  const MqttSpecificException(super.message, {super.code});

  String get userMessage;
}

class MqttConnectionException extends MqttSpecificException {
  const MqttConnectionException({String? message})
    : super(
        message ?? 'MQTT broker connection failed',
        code: 'MQTT_CONNECTION',
      );

  @override
  String get userMessage => 'サーバーへの接続に失敗しました。ネットワーク設定を確認してください。';
}

class MqttAuthException extends MqttSpecificException {
  const MqttAuthException({String? message})
    : super(message ?? 'MQTT authentication failed', code: 'MQTT_AUTH');

  @override
  String get userMessage => '認証に失敗しました。証明書またはクレデンシャルを確認してください。';
}

class MqttPublishException extends MqttSpecificException {
  const MqttPublishException({String? message})
    : super(message ?? 'MQTT publish failed', code: 'MQTT_PUBLISH');

  @override
  String get userMessage => 'メッセージの送信に失敗しました。接続状態を確認してください。';
}

class MqttSubscribeException extends MqttSpecificException {
  const MqttSubscribeException({String? message})
    : super(message ?? 'MQTT subscribe failed', code: 'MQTT_SUBSCRIBE');

  @override
  String get userMessage => 'トピックの購読に失敗しました。再接続してください。';
}

class MqttTimeoutException extends MqttSpecificException {
  const MqttTimeoutException({this.timeoutSec = 10, String? message})
    : super(message ?? 'MQTT response timed out', code: 'MQTT_TIMEOUT');

  final int timeoutSec;

  @override
  String get userMessage => '応答がタイムアウトしました（$timeoutSec秒）。再試行してください。';
}

class MqttUnknownException extends MqttSpecificException {
  const MqttUnknownException({this.cause, String? message})
    : super(message ?? 'Unknown MQTT error', code: 'MQTT_UNKNOWN');

  final Object? cause;

  @override
  String get userMessage => '予期しないエラーが発生しました。アプリを再起動してください。';
}
