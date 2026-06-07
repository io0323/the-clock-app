import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_clock_app/domain/repositories/mqtt_repository.dart';
import 'package:the_clock_app/domain/usecases/mqtt/connect_mqtt_usecase.dart';

class MockMqttRepository extends Mock implements MqttRepository {}

void main() {
  late MockMqttRepository mockRepository;
  late ConnectMqttUseCase useCase;

  setUp(() {
    mockRepository = MockMqttRepository();
    useCase = ConnectMqttUseCase(mockRepository, deviceId: 'test-device');
  });

  group('ConnectMqttUseCase', () {
    test('calls subscribeAll after successful connect', () async {
      when(() => mockRepository.connect()).thenAnswer((_) async {});
      when(() => mockRepository.subscribeAll(any())).thenAnswer((_) async {});

      await useCase.call();

      verify(() => mockRepository.connect()).called(1);
      verify(() => mockRepository.subscribeAll(any())).called(1);
    });

    test('retries with backoff on connection failure', () {
      fakeAsync((async) {
        var callCount = 0;
        when(() => mockRepository.connect()).thenAnswer((_) async {
          callCount++;
          if (callCount < 3) throw Exception('Connection failed');
        });
        when(() => mockRepository.subscribeAll(any())).thenAnswer((_) async {});

        var completed = false;
        useCase.call().then((_) => completed = true);

        async.elapse(const Duration(seconds: 10));

        expect(completed, isTrue);
        verify(() => mockRepository.connect()).called(3);
        verify(() => mockRepository.subscribeAll(any())).called(1);
      });
    });

    test('throws after exceeding max retries', () {
      fakeAsync((async) {
        when(
          () => mockRepository.connect(),
        ).thenThrow(Exception('Connection failed'));

        Object? caughtError;
        useCase.call().catchError((Object e) {
          caughtError = e;
        });

        async.elapse(const Duration(hours: 1));

        expect(caughtError, isA<Exception>());
      });
    });
  });
}
