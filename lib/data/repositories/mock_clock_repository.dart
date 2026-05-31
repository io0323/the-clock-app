import 'package:logger/logger.dart';

import '../../domain/entities/ble_connection_status.dart';
import '../../domain/entities/brightness_level.dart';
import '../../domain/entities/clock_state.dart';
import '../../domain/repositories/clock_repository.dart';

class MockClockRepository implements ClockRepository {
  final _logger = Logger();

  @override
  Stream<ClockState> watchClockState() {
    return Stream.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      return ClockState(
        currentTime: now,
        lightHourProgress: now.hour / 24 + now.minute / 1440,
        bleStatus: BleConnectionStatus.connected,
        isAlarmActive: false,
        alarmTime: '07:30',
        volume: 0.6,
        brightness: BrightnessLevel.medium,
      );
    });
  }

  @override
  Future<void> setAlarm(String time) async {
    _logger.d('MockClockRepository.setAlarm: $time');
  }

  @override
  Future<void> cancelAlarm() async {
    _logger.d('MockClockRepository.cancelAlarm');
  }

  @override
  Future<void> setBrightness(BrightnessLevel level) async {
    _logger.d('MockClockRepository.setBrightness: $level');
  }

  @override
  Future<void> setVolume(double volume) async {
    _logger.d('MockClockRepository.setVolume: $volume');
  }
}
