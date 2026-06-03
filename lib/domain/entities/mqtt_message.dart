class MqttMessage {
  const MqttMessage({
    required this.topic,
    required this.payload,
    required this.receivedAt,
    this.qos = 0,
    this.retained = false,
  });

  final String topic;
  final Map<String, dynamic> payload;
  final DateTime receivedAt;
  final int qos;
  final bool retained;
}
