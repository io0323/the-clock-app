import 'alarm_sound.dart';

class AlarmTriggerEvent {
  const AlarmTriggerEvent({
    required this.alarmId,
    required this.deviceId,
    required this.triggeredAt,
    required this.sound,
    required this.volume,
  });

  final String alarmId;
  final String deviceId;
  final DateTime triggeredAt;
  final AlarmSound sound;
  final double volume;

  factory AlarmTriggerEvent.fromJson(Map<String, dynamic> json) {
    return AlarmTriggerEvent(
      alarmId: json['alarm_id'] as String,
      deviceId: json['device_id'] as String,
      triggeredAt: DateTime.parse(json['triggered_at'] as String),
      sound: AlarmSound.values.byName(json['sound'] as String),
      volume: (json['volume'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alarm_id': alarmId,
      'device_id': deviceId,
      'triggered_at': triggeredAt.toIso8601String(),
      'sound': sound.mqttValue,
      'volume': volume,
    };
  }
}
