import '../../../core/constants/mqtt_topics.dart';
import '../../repositories/mqtt_repository.dart';

class PublishAlarmUseCase {
  const PublishAlarmUseCase(this._repository);

  final MqttRepository _repository;

  Future<void> call({
    required String deviceId,
    required String time,
    required String sound,
    required double volume,
  }) async {
    final topics = MqttTopics(deviceId);

    await _repository.publish(
      topics.alarmSet,
      {
        'time': time,
        'sound': sound,
        'volume': volume,
        'active': true,
      },
    );
  }
}
