import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/mqtt_datasource.dart';
import '../../data/datasources/rest_datasource.dart';
import '../../data/repositories/mqtt_repository_impl.dart';
import '../../domain/entities/device_shadow.dart';
import '../../domain/entities/mqtt_message.dart';
import '../../domain/entities/sensor_data.dart';
import '../../domain/repositories/mqtt_repository.dart';
import '../../domain/usecases/mqtt/connect_mqtt_usecase.dart';
import '../../domain/usecases/mqtt/publish_alarm_usecase.dart';
import '../../domain/usecases/mqtt/sync_device_shadow_usecase.dart';
import '../../domain/usecases/mqtt/watch_sensor_usecase.dart';

// --- DataSource ---

final mqttDataSourceProvider = Provider<MqttDataSource>((ref) {
  final ds = MqttDataSource();
  ref.onDispose(ds.dispose);
  return ds;
});

final restDataSourceProvider = Provider<RestDataSource>((ref) {
  return RestDataSource();
});

// --- Repository ---

final mqttRepositoryProvider = Provider<MqttRepository>((ref) {
  return MqttRepositoryImpl(
    ref.watch(mqttDataSourceProvider),
    ref.watch(restDataSourceProvider),
  );
});

// --- UseCase ---

const _defaultDeviceId = 'default';

final connectMqttUseCaseProvider = Provider<ConnectMqttUseCase>((ref) {
  return ConnectMqttUseCase(
    ref.watch(mqttRepositoryProvider),
    deviceId: _defaultDeviceId,
  );
});

final syncDeviceShadowUseCaseProvider =
    Provider<SyncDeviceShadowUseCase>((ref) {
  return SyncDeviceShadowUseCase(ref.watch(mqttRepositoryProvider));
});

final publishAlarmUseCaseProvider = Provider<PublishAlarmUseCase>((ref) {
  return PublishAlarmUseCase(ref.watch(mqttRepositoryProvider));
});

final watchSensorUseCaseProvider = Provider<WatchSensorUseCase>((ref) {
  return WatchSensorUseCase(ref.watch(mqttRepositoryProvider));
});

// --- UI購読用 ---

final deviceShadowProvider = FutureProvider<DeviceShadow>((ref) {
  final useCase = ref.watch(syncDeviceShadowUseCaseProvider);
  return useCase.call(_defaultDeviceId);
});

final sensorDataProvider = StreamProvider<SensorData>((ref) {
  final useCase = ref.watch(watchSensorUseCaseProvider);
  return useCase.call(_defaultDeviceId);
});

final mqttConnectionStatusProvider =
    StreamProvider<MqttConnectionStatus>((ref) {
  final repository = ref.watch(mqttRepositoryProvider);
  return repository.watchConnectionStatus();
});

final recentMqttMessagesProvider =
    StateNotifierProvider<RecentMessagesNotifier, List<MqttMessage>>((ref) {
  final repository = ref.watch(mqttRepositoryProvider);
  return RecentMessagesNotifier(repository);
});

class RecentMessagesNotifier extends StateNotifier<List<MqttMessage>> {
  RecentMessagesNotifier(this._repository) : super(const []) {
    _subscription = _repository.watchMessages().listen((message) {
      state = [message, ...state].take(10).toList();
    });
  }

  final MqttRepository _repository;
  StreamSubscription<MqttMessage>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
