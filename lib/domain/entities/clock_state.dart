import 'ble_connection_status.dart';
import 'brightness_level.dart';

class ClockState {
  const ClockState({
    required this.currentTime,
    required this.lightHourProgress,
    required this.bleStatus,
    required this.isAlarmActive,
    this.alarmTime,
    required this.volume,
    required this.brightness,
  });

  final DateTime currentTime;
  final double lightHourProgress;
  final BleConnectionStatus bleStatus;
  final bool isAlarmActive;
  final String? alarmTime;
  final double volume;
  final BrightnessLevel brightness;

  ClockState copyWith({
    DateTime? currentTime,
    double? lightHourProgress,
    BleConnectionStatus? bleStatus,
    bool? isAlarmActive,
    String? Function()? alarmTime,
    double? volume,
    BrightnessLevel? brightness,
  }) {
    return ClockState(
      currentTime: currentTime ?? this.currentTime,
      lightHourProgress: lightHourProgress ?? this.lightHourProgress,
      bleStatus: bleStatus ?? this.bleStatus,
      isAlarmActive: isAlarmActive ?? this.isAlarmActive,
      alarmTime: alarmTime != null ? alarmTime() : this.alarmTime,
      volume: volume ?? this.volume,
      brightness: brightness ?? this.brightness,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClockState &&
          runtimeType == other.runtimeType &&
          currentTime == other.currentTime &&
          lightHourProgress == other.lightHourProgress &&
          bleStatus == other.bleStatus &&
          isAlarmActive == other.isAlarmActive &&
          alarmTime == other.alarmTime &&
          volume == other.volume &&
          brightness == other.brightness;

  @override
  int get hashCode => Object.hash(
    currentTime,
    lightHourProgress,
    bleStatus,
    isAlarmActive,
    alarmTime,
    volume,
    brightness,
  );
}
