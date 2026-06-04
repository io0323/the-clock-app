import '../../../core/constants/mqtt_topics.dart';
import '../../entities/sensor_data.dart';
import '../../repositories/mqtt_repository.dart';

class WatchSensorUseCase {
  const WatchSensorUseCase(this._repository);

  final MqttRepository _repository;

  Stream<SensorData> call(String deviceId) {
    final topics = MqttTopics(deviceId);

    return _repository
        .watchMessages()
        .where((msg) => msg.topic == topics.sensor)
        .map((msg) => SensorData.fromJson(msg.payload));
  }
}
