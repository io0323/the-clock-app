import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_clock_app/domain/entities/ble_device.dart';
import 'package:the_clock_app/domain/repositories/ble_repository.dart';
import 'package:the_clock_app/domain/usecases/ble/scan_devices_usecase.dart';

class MockBleRepository extends Mock implements BleRepository {}

BleDevice _device({
  required String id,
  required int rssi,
  String name = 'io0323_CLOCK_TEST',
}) {
  return BleDevice(
    id: id,
    name: name,
    rssi: rssi,
    isConnectable: true,
    discoveredAt: DateTime(2026),
  );
}

void main() {
  late MockBleRepository mockRepository;
  late ScanDevicesUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const Duration(seconds: 30));
  });

  setUp(() {
    mockRepository = MockBleRepository();
    useCase = ScanDevicesUseCase(mockRepository);
  });

  group('ScanDevicesUseCase', () {
    test('filters out devices with RSSI below -90', () async {
      when(
        () => mockRepository.scanDevices(
          timeout: any(named: 'timeout'),
          nameFilter: any(named: 'nameFilter'),
        ),
      ).thenAnswer(
        (_) => Stream.fromIterable([
          _device(id: 'a', rssi: -60),
          _device(id: 'b', rssi: -95),
          _device(id: 'c', rssi: -90),
        ]),
      );

      final results = await useCase.call().toList();

      expect(results.length, 2);
      expect(results[0].id, 'a');
      expect(results[1].id, 'c');
    });

    test('removes duplicate devices by id', () async {
      when(
        () => mockRepository.scanDevices(
          timeout: any(named: 'timeout'),
          nameFilter: any(named: 'nameFilter'),
        ),
      ).thenAnswer(
        (_) => Stream.fromIterable([
          _device(id: 'a', rssi: -60),
          _device(id: 'a', rssi: -55),
          _device(id: 'b', rssi: -70),
        ]),
      );

      final results = await useCase.call().toList();

      expect(results.length, 2);
      expect(results[0].id, 'a');
      expect(results[1].id, 'b');
    });

    test('passes default name filter', () async {
      when(
        () => mockRepository.scanDevices(
          timeout: any(named: 'timeout'),
          nameFilter: any(named: 'nameFilter'),
        ),
      ).thenAnswer((_) => const Stream.empty());

      await useCase.call().toList();

      verify(
        () => mockRepository.scanDevices(
          timeout: any(named: 'timeout'),
          nameFilter: BleRepository.deviceNamePrefix,
        ),
      ).called(1);
    });

    test('emits nothing when all devices are below RSSI threshold', () async {
      when(
        () => mockRepository.scanDevices(
          timeout: any(named: 'timeout'),
          nameFilter: any(named: 'nameFilter'),
        ),
      ).thenAnswer(
        (_) => Stream.fromIterable([
          _device(id: 'a', rssi: -91),
          _device(id: 'b', rssi: -100),
        ]),
      );

      final results = await useCase.call().toList();

      expect(results, isEmpty);
    });
  });
}
