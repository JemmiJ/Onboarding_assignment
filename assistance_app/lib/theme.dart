import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4A90E2);
  static const Color background = Color(0xFFF5F5F5);
  static const Color textprimary = Color(0xFF333333);
  static const Color textsecondary = Color(0xFF777777);
  static const Color text2 = Color.fromRGBO(26, 32, 47, 1);
  static const Color accent = Color(0xFF50E3C2);
  static const Color cardBackground = Color.fromARGB(255, 253, 253, 253);
  static const Color border = Color(0xFFE0E0E0);
  static const Color buttonprimary = Color.fromRGBO(255, 64, 64, 1);
  static const Color text = Color.fromRGBO(255, 67, 67, 1);
  static const Color buttontext = Color.fromRGBO(238, 237, 237, 1);
}

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: 'Roboto',
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.text2,
    ),
    bodyLarge: TextStyle(fontSize: 16, color: AppColors.textprimary),
    bodyMedium: TextStyle(fontSize: 16, color: AppColors.textsecondary),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.buttonprimary),
);
