import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('REST shadow endpoint returns valid DeviceShadow JSON', () async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(
        Uri.parse('http://localhost:8080/shadow'),
      );
      final response = await request.close();
      expect(response.statusCode, 200);

      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;

      expect(json['deviceId'], 'test-device');
      expect(json['alarmTime'], '07:30');
      expect(json['alarmSound'], 'rain');
      expect(json['volume'], 0.6);
      expect(json['brightness'], 'medium');
      expect(json['firmwareVersion'], 240);
    } finally {
      client.close();
    }
  });

  test('REST routed endpoint /devices/:id/shadow works', () async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(
        Uri.parse('http://localhost:8080/devices/test-device/shadow'),
      );
      final response = await request.close();
      expect(response.statusCode, 200);

      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;

      expect(json['deviceId'], 'test-device');
      expect(json['firmwareVersion'], 240);
    } finally {
      client.close();
    }
  });
}
