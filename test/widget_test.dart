import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:the_clock_app/core/constants/app_theme.dart';
import 'package:the_clock_app/presentation/providers/clock_provider.dart';
import 'package:the_clock_app/presentation/screens/home/home_screen.dart';

void main() {
  testWidgets('HomeScreen renders title and clock', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          clockStateProvider.overrideWith((ref) => const Stream.empty()),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const HomeScreen(),
        ),
      ),
    );

    expect(find.text('The Clock'), findsOneWidget);
    expect(find.text('BALMUDA Connect'), findsOneWidget);
  });
}
