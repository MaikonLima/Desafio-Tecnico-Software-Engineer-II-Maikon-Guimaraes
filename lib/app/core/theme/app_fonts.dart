import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppFonts {
  static const title = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const body = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    color: AppColors.text,
  );

  static const subtitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
  );

  static const buttonText = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    color: Color(0xFF3366CC),
  );

  static const priceGreen = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: Color(0xFF5EC401),
  );
}
