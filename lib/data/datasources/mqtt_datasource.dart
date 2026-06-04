import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../core/constants/env.dart';
import '../../core/errors/mqtt_exception.dart';
import '../../domain/entities/mqtt_message.dart' as domain;
import '../../domain/repositories/mqtt_repository.dart';

class MqttDataSource {
  MqttDataSource() {
    final useTls = Env.mqttUseTls;
    final port = useTls ? 8883 : Env.mqttPort;

    _client = MqttServerClient.withPort(Env.mqttHost, Env.mqttClientId, port);
    _client.setProtocolV311();
    _client.keepAlivePeriod = 60;
    _client.autoReconnect = true;
    _client.logging(on: kDebugMode);

    if (useTls) {
      _client.secure = true;
      final context = SecurityContext.defaultContext;
      context.setTrustedCertificates('assets/certs/ca.pem');
      _client.securityContext = context;
    }

    _client.onConnected = _onConnected;
    _client.onDisconnected = _onDisconnected;
    _client.onAutoReconnect = _onAutoReconnect;
    _client.onAutoReconnected = _onAutoReconnected;

    _client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(Env.mqttClientId)
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
  }

  late final MqttServerClient _client;

  final _statusController =
      StreamController<MqttConnectionStatus>.broadcast();
  final _messagesController = StreamController<domain.MqttMessage>.broadcast();

  List<String> _subscribedTopics = [];
  StreamSubscription<List<MqttReceivedMessage<MqttMessage?>>>? _updatesSubscription;

  Future<void> connect() async {
    _statusController.add(MqttConnectionStatus.connecting);
    try {
      await _client.connect();
    } on NoConnectionException catch (e) {
      _statusController.add(MqttConnectionStatus.error);
      throw MqttConnectionException(message: e.toString());
    } on SocketException catch (e) {
      _statusController.add(MqttConnectionStatus.error);
      throw MqttConnectionException(message: e.toString());
    } on Exception catch (e) {
      _statusController.add(MqttConnectionStatus.error);
      throw MqttUnknownException(cause: e);
    }

    if (_client.connectionStatus?.state != MqttConnectionState.connected) {
      _statusController.add(MqttConnectionStatus.error);
      throw const MqttConnectionException();
    }

    _listenToUpdates();
  }

  Future<void> disconnect() async {
    _updatesSubscription?.cancel();
    _updatesSubscription = null;
    _client.disconnect();
    _statusController.add(MqttConnectionStatus.disconnected);
  }

  Stream<MqttConnectionStatus> watchConnectionStatus() =>
      _statusController.stream;

  Stream<domain.MqttMessage> watchMessages() => _messagesController.stream;

  Future<void> subscribeAll(List<String> topics) async {
    _subscribedTopics = topics;
    try {
      for (final topic in topics) {
        _client.subscribe(topic, MqttQos.atLeastOnce);
      }
    } on Exception catch (e) {
      throw MqttSubscribeException(message: e.toString());
    }
  }

  Future<void> publish(
    String topic,
    Map<String, dynamic> payload, {
    int qos = 1,
  }) async {
    try {
      final builder = MqttClientPayloadBuilder()
        ..addString(jsonEncode(payload));
      _client.publishMessage(
        topic,
        _toMqttQos(qos),
        builder.payload!,
      );
    } on Exception catch (e) {
      throw MqttPublishException(message: e.toString());
    }
  }

  void dispose() {
    _updatesSubscription?.cancel();
    _statusController.close();
    _messagesController.close();
    _client.disconnect();
  }

  void _listenToUpdates() {
    _updatesSubscription?.cancel();
    _updatesSubscription = _client.updates
        ?.listen((List<MqttReceivedMessage<MqttMessage?>> messages) {
      for (final msg in messages) {
        final pubMsg = msg.payload as MqttPublishMessage;
        final payloadStr = MqttPublishPayload.bytesToStringAsString(
          pubMsg.payload.message,
        );

        try {
          final json =
              jsonDecode(payloadStr) as Map<String, dynamic>;
          _messagesController.add(domain.MqttMessage(
            topic: msg.topic,
            payload: json,
            receivedAt: DateTime.now(),
            qos: pubMsg.header?.qos.index ?? 0,
            retained: pubMsg.header?.retain ?? false,
          ));
        } on FormatException catch (e) {
          debugPrint('MQTT JSON parse error on ${msg.topic}: $e');
        }
      }
    });
  }

  void _onConnected() {
    _statusController.add(MqttConnectionStatus.connected);
  }

  void _onDisconnected() {
    _statusController.add(MqttConnectionStatus.disconnected);
  }

  void _onAutoReconnect() {
    _statusController.add(MqttConnectionStatus.reconnecting);
  }

  void _onAutoReconnected() {
    _statusController.add(MqttConnectionStatus.connected);
    _listenToUpdates();
    if (_subscribedTopics.isNotEmpty) {
      for (final topic in _subscribedTopics) {
        _client.subscribe(topic, MqttQos.atLeastOnce);
      }
    }
  }

  MqttQos _toMqttQos(int qos) => switch (qos) {
        0 => MqttQos.atMostOnce,
        2 => MqttQos.exactlyOnce,
        _ => MqttQos.atLeastOnce,
      };
}
