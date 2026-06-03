class BleDevice {
  const BleDevice({
    required this.id,
    required this.name,
    required this.rssi,
    required this.isConnectable,
    required this.discoveredAt,
  });

  final String id;
  final String name;
  final int rssi;
  final bool isConnectable;
  final DateTime discoveredAt;

  BleDevice copyWith({
    String? id,
    String? name,
    int? rssi,
    bool? isConnectable,
    DateTime? discoveredAt,
  }) {
    return BleDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      rssi: rssi ?? this.rssi,
      isConnectable: isConnectable ?? this.isConnectable,
      discoveredAt: discoveredAt ?? this.discoveredAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BleDevice && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BleDevice(id: $id, name: $name, rssi: $rssi)';
}
