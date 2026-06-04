import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class Env {
  // REST API
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static int get apiTimeoutSec =>
      int.tryParse(dotenv.env['API_TIMEOUT_SEC'] ?? '') ?? 30;

  // MQTT
  static String get mqttHost => dotenv.env['MQTT_HOST'] ?? 'localhost';
  static int get mqttPort =>
      int.tryParse(dotenv.env['MQTT_PORT'] ?? '') ?? 1883;
  static String get mqttClientId =>
      dotenv.env['MQTT_CLIENT_ID'] ?? 'the_clock_app';
  static bool get mqttUseTls =>
      dotenv.env['MQTT_USE_TLS']?.toLowerCase() == 'true';

  // BLE
  static String get bleDeviceNamePrefix =>
      dotenv.env['BLE_DEVICE_NAME_PREFIX'] ?? 'BALMUDA_CLOCK';
  static int get bleConnectionTimeoutSec =>
      int.tryParse(dotenv.env['BLE_CONNECTION_TIMEOUT_SEC'] ?? '') ?? 10;
}
