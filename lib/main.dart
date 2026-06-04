import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_theme.dart';
import 'data/repositories/mock_clock_repository.dart';
import 'domain/entities/ble_connection_status.dart';
import 'presentation/providers/ble_provider.dart';
import 'presentation/providers/clock_provider.dart';
import 'presentation/providers/mqtt_provider.dart';
import 'presentation/screens/home/home_screen.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        clockRepositoryProvider.overrideWithValue(MockClockRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _initMqtt();
  }

  Future<void> _initMqtt() async {
    try {
      await ref.read(connectMqttUseCaseProvider).call();
    } on Exception catch (e) {
      debugPrint('MQTT initial connection failed: $e');
    }

    ref.listenManual(bleConnectionStateProvider, (prev, next) {
      final status = next.valueOrNull?.status;
      if (status == BleConnectionStatus.connected) {
        _syncShadow();
      }
    });
  }

  Future<void> _syncShadow() async {
    try {
      ref.invalidate(deviceShadowProvider);
    } on Exception catch (e) {
      debugPrint('Shadow sync failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Clock',
      theme: AppTheme.dark,
      home: const HomeScreen(),
    );
  }
}
