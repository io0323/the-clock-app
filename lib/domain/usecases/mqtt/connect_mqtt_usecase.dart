import 'dart:math';

import '../../../core/constants/mqtt_topics.dart';
import '../../repositories/mqtt_repository.dart';

class ConnectMqttUseCase {
  ConnectMqttUseCase(this._repository, {required this.deviceId});

  final MqttRepository _repository;
  final String deviceId;

  static const int maxRetries = 10;
  static const Duration _maxBackoff = Duration(seconds: 30);

  Future<void> call() async {
    var retryCount = 0;

    while (true) {
      try {
        await _repository.connect();
        final topics = MqttTopics(deviceId);
        await _repository.subscribeAll(topics.allSubscribeTopics);
        return;
      } on Exception {
        retryCount++;
        if (retryCount > maxRetries) rethrow;

        final backoff = Duration(
          seconds: min(pow(2, retryCount).toInt(), _maxBackoff.inSeconds),
        );
        await Future<void>.delayed(backoff);
      }
    }
  }
}
