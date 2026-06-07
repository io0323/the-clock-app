import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_clock_app/domain/repositories/mqtt_repository.dart';
import 'package:the_clock_app/domain/usecases/mqtt/publish_alarm_usecase.dart';

class MockMqttRepository extends Mock implements MqttRepository {}

void main() {
  late MockMqttRepository mockRepository;
  late PublishAlarmUseCase useCase;

  setUp(() {
    mockRepository = MockMqttRepository();
    useCase = PublishAlarmUseCase(mockRepository);
  });

  group('PublishAlarmUseCase', () {
    test('publishes correct payload to alarm/set topic', () async {
      when(
        () => mockRepository.publish(any(), any(), qos: any(named: 'qos')),
      ).thenAnswer((_) async {});

      await useCase.call(
        deviceId: 'test-device',
        time: '07:30',
        sound: 'rain',
        volume: 0.6,
      );

      verify(
        () => mockRepository.publish('balmuda/test-device/alarm/set', {
          'time': '07:30',
          'sound': 'rain',
          'volume': 0.6,
          'active': true,
        }),
      ).called(1);
    });
  });
}
