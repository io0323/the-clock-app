import 'package:logger/logger.dart';

import '../../core/utils/demo_data.dart';
import '../../domain/entities/brightness_level.dart';
import '../../domain/entities/clock_state.dart';
import '../../domain/repositories/clock_repository.dart';

class MockClockRepository implements ClockRepository {
  final _logger = Logger();

  @override
  Stream<ClockState> watchClockState() {
    final hero = DemoData.heroState;
    return Stream.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      return hero.copyWith(
        currentTime: now,
        lightHourProgress: now.hour / 24 + now.minute / 1440,
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
