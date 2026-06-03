import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_clock_app/domain/entities/ble_connection_state.dart';
import 'package:the_clock_app/domain/entities/ble_connection_status.dart';
import 'package:the_clock_app/domain/entities/ble_device.dart';
import 'package:the_clock_app/domain/repositories/ble_repository.dart';
import 'package:the_clock_app/domain/usecases/ble/connect_device_usecase.dart';

class MockBleRepository extends Mock implements BleRepository {}

class FakeBleDevice extends Fake implements BleDevice {}

void main() {
  late MockBleRepository mockRepository;
  late ConnectDeviceUseCase useCase;
  late BleDevice device;

  setUpAll(() {
    registerFallbackValue(FakeBleDevice());
    registerFallbackValue(const Duration(seconds: 10));
  });

  setUp(() {
    mockRepository = MockBleRepository();
    useCase = ConnectDeviceUseCase(mockRepository);
    device = BleDevice(
      id: 'test-id',
      name: 'BALMUDA_CLOCK_TEST',
      rssi: -60,
      isConnectable: true,
      discoveredAt: DateTime(2026),
    );
  });

  group('ConnectDeviceUseCase', () {
    test('connects successfully and reads RSSI', () async {
      when(() => mockRepository.watchConnectionState()).thenAnswer(
        (_) => Stream.value(BleConnectionState.initial),
      );
      when(() => mockRepository.connect(any(), timeout: any(named: 'timeout')))
          .thenAnswer((_) async {});
      when(() => mockRepository.readRssi()).thenAnswer((_) async => -55);

      await useCase.call(device);

      verify(() => mockRepository.connect(any(), timeout: any(named: 'timeout')))
          .called(1);
      verify(() => mockRepository.readRssi()).called(1);
    });

    test('skips connection when already connecting', () async {
      when(() => mockRepository.watchConnectionState()).thenAnswer(
        (_) => Stream.value(const BleConnectionState(
          status: BleConnectionStatus.connecting,
        )),
      );

      await useCase.call(device);

      verifyNever(
        () => mockRepository.connect(any(), timeout: any(named: 'timeout')),
      );
    });

    test('throws StateError when scanning', () async {
      when(() => mockRepository.watchConnectionState()).thenAnswer(
        (_) => Stream.value(const BleConnectionState(
          status: BleConnectionStatus.scanning,
        )),
      );

      expect(() => useCase.call(device), throwsStateError);
    });

    test('connects even if readRssi fails', () async {
      when(() => mockRepository.watchConnectionState()).thenAnswer(
        (_) => Stream.value(BleConnectionState.initial),
      );
      when(() => mockRepository.connect(any(), timeout: any(named: 'timeout')))
          .thenAnswer((_) async {});
      when(() => mockRepository.readRssi())
          .thenThrow(Exception('RSSI read failed'));

      await useCase.call(device);

      verify(() => mockRepository.connect(any(), timeout: any(named: 'timeout')))
          .called(1);
    });
  });
}
