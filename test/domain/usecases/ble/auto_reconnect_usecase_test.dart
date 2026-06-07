import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_clock_app/domain/entities/ble_connection_state.dart';
import 'package:the_clock_app/domain/entities/ble_connection_status.dart';
import 'package:the_clock_app/domain/entities/ble_device.dart';
import 'package:the_clock_app/domain/repositories/ble_repository.dart';
import 'package:the_clock_app/domain/usecases/ble/auto_reconnect_usecase.dart';

class MockBleRepository extends Mock implements BleRepository {}

class FakeBleDevice extends Fake implements BleDevice {}

void main() {
  late MockBleRepository mockRepository;
  late AutoReconnectUseCase useCase;
  late StreamController<BleConnectionState> stateController;
  late BleDevice device;

  setUpAll(() {
    registerFallbackValue(FakeBleDevice());
    registerFallbackValue(const Duration(seconds: 10));
  });

  setUp(() {
    mockRepository = MockBleRepository();
    useCase = AutoReconnectUseCase(mockRepository);
    stateController = StreamController<BleConnectionState>.broadcast();
    device = BleDevice(
      id: 'test-id',
      name: 'io0323_CLOCK_TEST',
      rssi: -60,
      isConnectable: true,
      discoveredAt: DateTime(2026),
    );

    when(
      () => mockRepository.watchConnectionState(),
    ).thenAnswer((_) => stateController.stream);
  });

  tearDown(() {
    useCase.cancel();
    stateController.close();
  });

  group('AutoReconnectUseCase', () {
    test('starts reconnection when connection is lost', () {
      fakeAsync((async) {
        when(
          () => mockRepository.connect(any(), timeout: any(named: 'timeout')),
        ).thenAnswer((_) async {});

        useCase.start(device);

        stateController.add(
          const BleConnectionState(status: BleConnectionStatus.lost),
        );

        async.elapse(const Duration(seconds: 2));

        verify(
          () => mockRepository.connect(any(), timeout: any(named: 'timeout')),
        ).called(greaterThanOrEqualTo(1));
      });
    });

    test('stops after maxRetries failures', () {
      fakeAsync((async) {
        var connectCount = 0;
        when(
          () => mockRepository.connect(any(), timeout: any(named: 'timeout')),
        ).thenAnswer((_) async {
          connectCount++;
          throw Exception('Connection failed');
        });

        useCase.start(device);

        stateController.add(
          const BleConnectionState(status: BleConnectionStatus.error),
        );

        async.elapse(const Duration(seconds: 120));

        expect(connectCount, equals(AutoReconnectUseCase.maxRetries));
      });
    });

    test('cancels reconnection on manual disconnect', () {
      fakeAsync((async) {
        var connectCount = 0;
        when(
          () => mockRepository.connect(any(), timeout: any(named: 'timeout')),
        ).thenAnswer((_) async {
          connectCount++;
          throw Exception('Connection failed');
        });

        useCase.start(device);

        stateController.add(
          const BleConnectionState(status: BleConnectionStatus.lost),
        );

        async.elapse(const Duration(seconds: 2));
        useCase.cancel();

        final countAtCancel = connectCount;
        async.elapse(const Duration(seconds: 30));

        expect(connectCount, equals(countAtCancel));
      });
    });
  });
}
