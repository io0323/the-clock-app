import '../entities/device_shadow.dart';
import '../entities/mqtt_message.dart';

abstract class MqttRepository {
  Future<void> connect();

  Future<void> disconnect();

  Stream<MqttConnectionStatus> watchConnectionStatus();

  Future<void> subscribeAll(List<String> topics);

  Stream<MqttMessage> watchMessages();

  Future<void> publish(
    String topic,
    Map<String, dynamic> payload, {
    int qos = 1,
  });

  Future<DeviceShadow> fetchShadow(String deviceId);
}

enum MqttConnectionStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}
