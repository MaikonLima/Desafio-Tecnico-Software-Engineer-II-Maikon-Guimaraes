import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundApp,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      fontFamily: 'Poppins',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundApp,
        foregroundColor: AppColors.text,
        elevation: 0,
      ),
    );
  }
}
