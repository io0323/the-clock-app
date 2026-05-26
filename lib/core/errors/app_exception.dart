class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'AppException($code): $message';
}

class BleException extends AppException {
  const BleException(super.message, {super.code});
}

class ApiException extends AppException {
  const ApiException(super.message, {super.code});
}

class MqttException extends AppException {
  const MqttException(super.message, {super.code});
}
