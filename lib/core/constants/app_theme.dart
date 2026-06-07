import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.jost().fontFamily,
    colorScheme: const ColorScheme.dark(
      surface: AppColors.surface,
      primary: AppColors.amber,
      secondary: AppColors.amberSoft,
      error: AppColors.error,
      onSurface: AppColors.textPrimary,
      onPrimary: AppColors.background,
      onSecondary: AppColors.background,
      onError: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceVariant,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
    ),
    dividerColor: AppColors.surfaceVariant,
  );
}
