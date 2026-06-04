class SensorData {
  const SensorData({
    required this.temperature,
    required this.humidity,
    required this.measuredAt,
  });

  final double temperature;
  final int humidity;
  final DateTime measuredAt;

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      temperature: (json['temperature'] as num).toDouble(),
      humidity: json['humidity'] as int,
      measuredAt: DateTime.parse(json['measuredAt'] as String),
    );
  }
}
