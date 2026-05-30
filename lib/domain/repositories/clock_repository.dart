import '../entities/brightness_level.dart';
import '../entities/clock_state.dart';

abstract class ClockRepository {
  Stream<ClockState> watchClockState();
  Future<void> setAlarm(String time);
  Future<void> cancelAlarm();
  Future<void> setBrightness(BrightnessLevel level);
  Future<void> setVolume(double volume);
}
