import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void main() {
  late MqttServerClient subClient;
  late MqttServerClient pubClient;

  setUp(() {
    subClient = MqttServerClient.withPort(
      'localhost',
      'test_sub_${DateTime.now().millisecondsSinceEpoch}',
      1883,
    );
    subClient.setProtocolV311();
    subClient.keepAlivePeriod = 20;
    subClient.logging(on: false);

    pubClient = MqttServerClient.withPort(
      'localhost',
      'test_pub_${DateTime.now().millisecondsSinceEpoch}',
      1883,
    );
    pubClient.setProtocolV311();
    pubClient.keepAlivePeriod = 20;
    pubClient.logging(on: false);
  });

  tearDown(() {
    subClient.disconnect();
    pubClient.disconnect();
  });

  test('MQTT pub/sub round-trip for alarm, sensor, shadow', () async {
    await subClient.connect();
    expect(subClient.connectionStatus?.state, MqttConnectionState.connected);

    subClient.subscribe('balmuda/#', MqttQos.atLeastOnce);

    final received = <String, Map<String, dynamic>>{};
    final completer = Completer<void>();

    subClient.updates?.listen((msgs) {
      for (final msg in msgs) {
        final pub = msg.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          pub.payload.message,
        );
        received[msg.topic] = jsonDecode(payload) as Map<String, dynamic>;
        if (received.length >= 3) completer.complete();
      }
    });

    await pubClient.connect();
    expect(pubClient.connectionStatus?.state, MqttConnectionState.connected);

    // Publish alarm
    final b1 = MqttClientPayloadBuilder()
      ..addString(
        jsonEncode({
          'time': '07:30',
          'sound': 'rain',
          'volume': 0.6,
          'active': true,
        }),
      );
    pubClient.publishMessage(
      'balmuda/test-device/alarm/set',
      MqttQos.atLeastOnce,
      b1.payload!,
    );

    // Publish sensor
    final b2 = MqttClientPayloadBuilder()
      ..addString(
        jsonEncode({
          'temperature': 23.5,
          'humidity': 55,
          'measuredAt': '2026-06-05T10:00:00Z',
        }),
      );
    pubClient.publishMessage(
      'balmuda/test-device/sensor',
      MqttQos.atLeastOnce,
      b2.payload!,
    );

    // Publish shadow response
    final b3 = MqttClientPayloadBuilder()
      ..addString(
        jsonEncode({
          'deviceId': 'test-device',
          'alarmActive': true,
          'alarmTime': '07:30',
          'alarmSound': 'rain',
          'volume': 0.6,
          'brightness': 'medium',
          'relaxModeActive': false,
          'relaxSound': 'rain',
          'lastUpdated': '2026-06-05T10:00:00Z',
          'firmwareVersion': 240,
        }),
      );
    pubClient.publishMessage(
      'balmuda/test-device/shadow/get/accepted',
      MqttQos.atLeastOnce,
      b3.payload!,
    );

    await completer.future.timeout(const Duration(seconds: 5));

    expect(received, contains('balmuda/test-device/alarm/set'));
    expect(received['balmuda/test-device/alarm/set']!['time'], '07:30');
    expect(received['balmuda/test-device/alarm/set']!['sound'], 'rain');
    expect(received['balmuda/test-device/alarm/set']!['volume'], 0.6);
    expect(received['balmuda/test-device/alarm/set']!['active'], true);

    expect(received, contains('balmuda/test-device/sensor'));
    expect(received['balmuda/test-device/sensor']!['temperature'], 23.5);
    expect(received['balmuda/test-device/sensor']!['humidity'], 55);

    expect(received, contains('balmuda/test-device/shadow/get/accepted'));
    expect(
      received['balmuda/test-device/shadow/get/accepted']!['alarmActive'],
      true,
    );
    expect(
      received['balmuda/test-device/shadow/get/accepted']!['firmwareVersion'],
      240,
    );
  });

  test('MQTT publish alarm config matches expected payload format', () async {
    await subClient.connect();
    subClient.subscribe('balmuda/+/alarm/set', MqttQos.atLeastOnce);

    final completer = Completer<Map<String, dynamic>>();
    subClient.updates?.listen((msgs) {
      for (final msg in msgs) {
        final pub = msg.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          pub.payload.message,
        );
        completer.complete(jsonDecode(payload) as Map<String, dynamic>);
      }
    });

    await pubClient.connect();
    final builder = MqttClientPayloadBuilder()
      ..addString(
        jsonEncode({
          'time': '22:15',
          'sound': 'piano',
          'volume': 0.8,
          'active': true,
        }),
      );
    pubClient.publishMessage(
      'balmuda/my-device/alarm/set',
      MqttQos.atLeastOnce,
      builder.payload!,
    );

    final result = await completer.future.timeout(const Duration(seconds: 5));
    expect(result['time'], '22:15');
    expect(result['sound'], 'piano');
    expect(result['volume'], 0.8);
    expect(result['active'], true);
  });
}
