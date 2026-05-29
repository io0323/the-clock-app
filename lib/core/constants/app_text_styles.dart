import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTextStyles {
  static TextStyle get displayLarge => GoogleFonts.cormorantGaramond(
        fontSize: 48,
        fontWeight: FontWeight.w300,
        color: AppColors.textPrimary,
      );

  static TextStyle get displayMedium => GoogleFonts.cormorantGaramond(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
        color: AppColors.textPrimary,
      );

  static TextStyle get timeDisplay => GoogleFonts.dmMono(
        fontSize: 32,
        fontWeight: FontWeight.w300,
        letterSpacing: 32 * 0.08,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelSmall => GoogleFonts.dmMono(
        fontSize: 10,
        fontWeight: FontWeight.w300,
        letterSpacing: 10 * 0.20,
        color: AppColors.textMuted,
      );

  static TextStyle get bodyMedium => GoogleFonts.jost(
        fontSize: 13,
        fontWeight: FontWeight.w300,
        letterSpacing: 13 * 0.02,
        color: AppColors.textPrimary,
      );
}
