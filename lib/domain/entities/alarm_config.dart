import 'alarm_sound.dart';
import 'alarm_weekday.dart';

class AlarmConfig {
  const AlarmConfig({
    required this.id,
    required this.active,
    required this.time,
    this.weekdays = const [],
    required this.sound,
    required this.volume,
    this.snoozeEnabled = false,
    this.snoozeMinutes = 5,
    this.label,
    required this.createdAt,
  });

  final String id;
  final bool active;
  final String time;
  final List<AlarmWeekday> weekdays;
  final AlarmSound sound;
  final double volume;
  final bool snoozeEnabled;
  final int snoozeMinutes;
  final String? label;
  final DateTime createdAt;

  AlarmConfig copyWith({
    String? id,
    bool? active,
    String? time,
    List<AlarmWeekday>? weekdays,
    AlarmSound? sound,
    double? volume,
    bool? snoozeEnabled,
    int? snoozeMinutes,
    String? label,
    DateTime? createdAt,
  }) {
    return AlarmConfig(
      id: id ?? this.id,
      active: active ?? this.active,
      time: time ?? this.time,
      weekdays: weekdays ?? this.weekdays,
      sound: sound ?? this.sound,
      volume: volume ?? this.volume,
      snoozeEnabled: snoozeEnabled ?? this.snoozeEnabled,
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory AlarmConfig.fromJson(Map<String, dynamic> json) {
    return AlarmConfig(
      id: json['id'] as String,
      active: json['active'] as bool,
      time: json['time'] as String,
      weekdays:
          (json['weekdays'] as List<dynamic>?)
              ?.map((e) => AlarmWeekday.values.byName(e as String))
              .toList() ??
          const [],
      sound: AlarmSound.values.byName(json['sound'] as String),
      volume: (json['volume'] as num).toDouble(),
      snoozeEnabled: json['snooze_enabled'] as bool? ?? false,
      snoozeMinutes: json['snooze_minutes'] as int? ?? 5,
      label: json['label'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'active': active,
      'time': time,
      'weekdays': weekdays.map((e) => e.name).toList(),
      'sound': sound.mqttValue,
      'volume': volume,
      'snooze_enabled': snoozeEnabled,
      'snooze_minutes': snoozeMinutes,
      'label': label,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
