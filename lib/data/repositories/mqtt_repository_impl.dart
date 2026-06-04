import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/constants/mqtt_topics.dart';
import '../../core/errors/mqtt_exception.dart';
import '../../domain/entities/device_shadow.dart';
import '../../domain/entities/mqtt_message.dart';
import '../../domain/repositories/mqtt_repository.dart';
import '../datasources/mqtt_datasource.dart';
import '../datasources/rest_datasource.dart';

class MqttRepositoryImpl implements MqttRepository {
  MqttRepositoryImpl(this._mqttDataSource, this._restDataSource);

  final MqttDataSource _mqttDataSource;
  final RestDataSource _restDataSource;

  @override
  Future<void> connect() => _mqttDataSource.connect();

  @override
  Future<void> disconnect() => _mqttDataSource.disconnect();

  @override
  Stream<MqttConnectionStatus> watchConnectionStatus() =>
      _mqttDataSource.watchConnectionStatus();

  @override
  Future<void> subscribeAll(List<String> topics) =>
      _mqttDataSource.subscribeAll(topics);

  @override
  Stream<MqttMessage> watchMessages() => _mqttDataSource.watchMessages();

  @override
  Future<void> publish(
    String topic,
    Map<String, dynamic> payload, {
    int qos = 1,
  }) async {
    try {
      await _mqttDataSource.publish(topic, payload, qos: qos);
    } on MqttSpecificException {
      rethrow;
    } on Exception catch (e) {
      throw MqttPublishException(message: e.toString());
    }
  }

  @override
  Future<DeviceShadow> fetchShadow(String deviceId) async {
    try {
      return await _restDataSource.getShadow(deviceId);
    } on Exception catch (restError) {
      debugPrint('REST shadow fetch failed, falling back to MQTT: $restError');
    }

    final topics = MqttTopics(deviceId);

    final shadowFuture = _mqttDataSource
        .watchMessages()
        .where((msg) => msg.topic == topics.shadow)
        .map((msg) => DeviceShadow.fromJson(msg.payload))
        .first
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw const MqttTimeoutException(timeoutSec: 5);
    });

    await _mqttDataSource.publish(topics.shadowGet, {});

    return shadowFuture;
  }
}
