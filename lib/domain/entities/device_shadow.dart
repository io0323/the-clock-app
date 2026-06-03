import 'brightness_level.dart';

class DeviceShadow {
  const DeviceShadow({
    required this.deviceId,
    required this.alarmActive,
    this.alarmTime,
    required this.alarmSound,
    required this.volume,
    required this.brightness,
    required this.relaxModeActive,
    required this.relaxSound,
    required this.lastUpdated,
    required this.firmwareVersion,
  });

  final String deviceId;
  final bool alarmActive;
  final String? alarmTime;
  final String alarmSound;
  final double volume;
  final BrightnessLevel brightness;
  final bool relaxModeActive;
  final String relaxSound;
  final DateTime lastUpdated;
  final int firmwareVersion;

  factory DeviceShadow.fromJson(Map<String, dynamic> json) {
    return DeviceShadow(
      deviceId: json['deviceId'] as String,
      alarmActive: json['alarmActive'] as bool,
      alarmTime: json['alarmTime'] as String?,
      alarmSound: json['alarmSound'] as String,
      volume: (json['volume'] as num).toDouble(),
      brightness: BrightnessLevel.values.byName(json['brightness'] as String),
      relaxModeActive: json['relaxModeActive'] as bool,
      relaxSound: json['relaxSound'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      firmwareVersion: json['firmwareVersion'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'alarmActive': alarmActive,
      'alarmTime': alarmTime,
      'alarmSound': alarmSound,
      'volume': volume,
      'brightness': brightness.name,
      'relaxModeActive': relaxModeActive,
      'relaxSound': relaxSound,
      'lastUpdated': lastUpdated.toIso8601String(),
      'firmwareVersion': firmwareVersion,
    };
  }

  DeviceShadow copyWith({
    String? deviceId,
    bool? alarmActive,
    String? alarmTime,
    String? alarmSound,
    double? volume,
    BrightnessLevel? brightness,
    bool? relaxModeActive,
    String? relaxSound,
    DateTime? lastUpdated,
    int? firmwareVersion,
  }) {
    return DeviceShadow(
      deviceId: deviceId ?? this.deviceId,
      alarmActive: alarmActive ?? this.alarmActive,
      alarmTime: alarmTime ?? this.alarmTime,
      alarmSound: alarmSound ?? this.alarmSound,
      volume: volume ?? this.volume,
      brightness: brightness ?? this.brightness,
      relaxModeActive: relaxModeActive ?? this.relaxModeActive,
      relaxSound: relaxSound ?? this.relaxSound,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      firmwareVersion: firmwareVersion ?? this.firmwareVersion,
    );
  }
}
