class AlarmConfig {
  const AlarmConfig({
    required this.id,
    required this.time,
    required this.sound,
    required this.volume,
    required this.active,
  });

  final String id;
  final String time;
  final String sound;
  final double volume;
  final bool active;

  factory AlarmConfig.fromJson(Map<String, dynamic> json) {
    return AlarmConfig(
      id: json['id'] as String,
      time: json['time'] as String,
      sound: json['sound'] as String,
      volume: (json['volume'] as num).toDouble(),
      active: json['active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'sound': sound,
      'volume': volume,
      'active': active,
    };
  }
}
