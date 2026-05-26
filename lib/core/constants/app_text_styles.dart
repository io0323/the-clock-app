import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static const heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const body = TextStyle(
    fontSize: 16,
    color: AppColors.white,
  );

  static const caption = TextStyle(
    fontSize: 12,
    color: AppColors.grey,
  );
}
