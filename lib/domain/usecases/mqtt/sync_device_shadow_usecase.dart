import 'dart:async';

import '../../../core/constants/mqtt_topics.dart';
import '../../../core/errors/mqtt_exception.dart';
import '../../entities/device_shadow.dart';
import '../../repositories/mqtt_repository.dart';

class SyncDeviceShadowUseCase {
  const SyncDeviceShadowUseCase(this._repository);

  final MqttRepository _repository;

  static const Duration _timeout = Duration(seconds: 5);

  Future<DeviceShadow> call(String deviceId) async {
    final topics = MqttTopics(deviceId);

    final shadowFuture = _repository
        .watchMessages()
        .where((msg) => msg.topic == topics.shadow)
        .map((msg) => DeviceShadow.fromJson(msg.payload))
        .first
        .timeout(
          _timeout,
          onTimeout: () {
            throw const MqttTimeoutException(timeoutSec: 5);
          },
        );

    await _repository.publish(topics.shadowGet, {});

    return shadowFuture;
  }
}
