import 'package:flutter/foundation.dart';

import '../../domain/entities/alarm_config.dart';
import '../../domain/entities/alarm_sound.dart';
import '../../domain/entities/alarm_weekday.dart';
import '../../domain/entities/alarm_trigger_event.dart';
import '../../domain/entities/ble_connection_status.dart';
import '../../domain/entities/brightness_level.dart';
import '../../domain/entities/clock_state.dart';
import '../../domain/entities/sensor_data.dart';

abstract final class DemoData {
  static bool get isEnabled => kDebugMode;

  static ClockState get heroState => ClockState(
    currentTime: DateTime(2026, 6, 6, 7, 28),
    lightHourProgress: 0.31,
    bleStatus: BleConnectionStatus.connected,
    isAlarmActive: true,
    alarmTime: '07:30',
    volume: 0.7,
    brightness: BrightnessLevel.medium,
  );

  static List<AlarmConfig> get alarms => [
    AlarmConfig(
      id: 'demo-001',
      active: true,
      time: '07:30',
      weekdays: [
        AlarmWeekday.mon,
        AlarmWeekday.tue,
        AlarmWeekday.wed,
        AlarmWeekday.thu,
        AlarmWeekday.fri,
      ],
      sound: AlarmSound.rain,
      volume: 0.7,
      snoozeEnabled: true,
      snoozeMinutes: 5,
      label: '平日の朝',
      createdAt: DateTime(2026, 6, 1),
    ),
    AlarmConfig(
      id: 'demo-002',
      active: false,
      time: '09:00',
      weekdays: [AlarmWeekday.sat, AlarmWeekday.sun],
      sound: AlarmSound.piano,
      volume: 0.5,
      label: '休日',
      createdAt: DateTime(2026, 6, 1),
    ),
  ];

  static SensorData get sensor =>
      SensorData(temperature: 23.4, humidity: 58, measuredAt: DateTime.now());

  static AlarmTriggerEvent get triggerEvent => AlarmTriggerEvent(
    alarmId: 'demo-001',
    deviceId: 'io0323_CLOCK_7A3F',
    triggeredAt: DateTime(2026, 6, 6, 7, 30),
    sound: AlarmSound.rain,
    volume: 0.7,
  );
}
