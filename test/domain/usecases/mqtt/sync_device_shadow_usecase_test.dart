import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_clock_app/core/errors/mqtt_exception.dart';
import 'package:the_clock_app/domain/entities/mqtt_message.dart';
import 'package:the_clock_app/domain/repositories/mqtt_repository.dart';
import 'package:the_clock_app/domain/usecases/mqtt/sync_device_shadow_usecase.dart';

class MockMqttRepository extends Mock implements MqttRepository {}

void main() {
  late MockMqttRepository mockRepository;
  late SyncDeviceShadowUseCase useCase;

  setUp(() {
    mockRepository = MockMqttRepository();
    useCase = SyncDeviceShadowUseCase(mockRepository);
  });

  group('SyncDeviceShadowUseCase', () {
    test('returns DeviceShadow on successful response', () async {
      final shadowJson = {
        'deviceId': 'test-device',
        'alarmActive': true,
        'alarmTime': '07:30',
        'alarmSound': 'rain',
        'volume': 0.6,
        'brightness': 'medium',
        'relaxModeActive': false,
        'relaxSound': 'none',
        'lastUpdated': '2026-01-01T00:00:00.000',
        'firmwareVersion': 1,
      };

      when(() => mockRepository.watchMessages()).thenAnswer(
        (_) => Stream.value(MqttMessage(
          topic: 'balmuda/test-device/shadow/get/accepted',
          payload: shadowJson,
          receivedAt: DateTime(2026),
        )),
      );
      when(() => mockRepository.publish(any(), any()))
          .thenAnswer((_) async {});

      final result = await useCase.call('test-device');

      expect(result.deviceId, 'test-device');
      expect(result.alarmActive, true);
      verify(() => mockRepository.publish(
            'balmuda/test-device/shadow/get',
            {},
          )).called(1);
    });

    test('throws MqttTimeoutException when no response', () async {
      when(() => mockRepository.watchMessages()).thenAnswer(
        (_) => Stream.periodic(const Duration(hours: 1))
            .map((_) => MqttMessage(
                  topic: 'other',
                  payload: {},
                  receivedAt: DateTime(2026),
                ))
            .where((_) => false),
      );
      when(() => mockRepository.publish(any(), any()))
          .thenAnswer((_) async {});

      await expectLater(
        useCase.call('test-device'),
        throwsA(isA<MqttTimeoutException>()),
      );
    });
  });
}
