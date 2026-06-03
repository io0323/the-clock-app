class MqttTopics {
  const MqttTopics(this.deviceId);

  final String deviceId;

  // Subscribe（デバイス→アプリ）
  String get status => 'balmuda/$deviceId/status';
  String get sensor => 'balmuda/$deviceId/sensor';
  String get alarm => 'balmuda/$deviceId/alarm';
  String get timer => 'balmuda/$deviceId/timer';
  String get light => 'balmuda/$deviceId/light';
  String get relax => 'balmuda/$deviceId/relax';
  String get shadow => 'balmuda/$deviceId/shadow/get/accepted';

  // Publish（アプリ→デバイス）
  String get alarmSet => 'balmuda/$deviceId/alarm/set';
  String get lightSet => 'balmuda/$deviceId/light/set';
  String get relaxSet => 'balmuda/$deviceId/relax/set';
  String get shadowGet => 'balmuda/$deviceId/shadow/get';
  String get shadowUpdate => 'balmuda/$deviceId/shadow/update';

  List<String> get allSubscribeTopics => [
    status,
    sensor,
    alarm,
    timer,
    light,
    relax,
    shadow,
  ];
}
