import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_theme.dart';
import 'data/repositories/mock_clock_repository.dart';
import 'presentation/providers/clock_provider.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Clock',
      theme: AppTheme.dark,
      home: const Scaffold(
        body: Center(
          child: Text('The Clock'),
        ),
      ),
    );
  }
}
