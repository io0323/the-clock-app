import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:the_clock_app/core/constants/app_theme.dart';
import 'package:the_clock_app/domain/entities/ble_connection_state.dart';
import 'package:the_clock_app/domain/entities/mqtt_message.dart';
import 'package:the_clock_app/domain/repositories/mqtt_repository.dart';
import 'package:the_clock_app/presentation/providers/ble_lifecycle_provider.dart';
import 'package:the_clock_app/presentation/providers/ble_provider.dart';
import 'package:the_clock_app/presentation/providers/clock_provider.dart';
import 'package:the_clock_app/presentation/providers/mqtt_provider.dart';
import 'package:the_clock_app/presentation/screens/home/home_screen.dart';

class _NoopBleLifecycleObserver extends BleLifecycleObserver {
  _NoopBleLifecycleObserver() : super(_FakeRef());
}

class _FakeRef extends Ref {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _EmptyMessagesNotifier extends StateNotifier<List<MqttMessage>>
    implements RecentMessagesNotifier {
  _EmptyMessagesNotifier() : super(const []);
}

void main() {
  testWidgets('HomeScreen renders title and clock', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clockStateProvider.overrideWith((ref) => const Stream.empty()),
          bleConnectionStateProvider.overrideWith(
            (ref) => Stream.value(BleConnectionState.initial),
          ),
          bleLifecycleProvider.overrideWithValue(
            _NoopBleLifecycleObserver(),
          ),
          mqttConnectionStatusProvider.overrideWith(
            (ref) => Stream.value(MqttConnectionStatus.disconnected),
          ),
          sensorDataProvider.overrideWith((ref) => const Stream.empty()),
          recentMqttMessagesProvider.overrideWith(
            (ref) => _EmptyMessagesNotifier(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const HomeScreen(),
        ),
      ),
    );

    expect(find.text('The Clock'), findsOneWidget);
    expect(find.text('io0323 Connect'), findsOneWidget);
  });
}
