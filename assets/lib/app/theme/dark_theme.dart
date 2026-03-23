import 'package:flutter/material.dart';
import 'theme_extensions.dart';

class DarkTheme {
  static ThemeData build(TextTheme baseText) {
    const brand = Color(0xFFF4A300);
    final cs = ColorScheme.fromSeed(
      seedColor: brand,
      brightness: Brightness.dark,
    );

    return ThemeData(
      colorScheme: cs.copyWith(
        primary: brand,
        onPrimary: Colors.white,
        surface: const Color(0xFF121212),       // خلفية أساسية داكنة
        onSurface: Colors.white,                // نص أساسي أبيض
        onSurfaceVariant: Colors.grey[400],     // نص ثانوي أو رمادي فاتح
      ),
      useMaterial3: true,
      textTheme: baseText.apply(
        bodyColor: Colors.white,                // نصوص عامة
        displayColor: Colors.white,             // عناوين
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          foregroundColor: Colors.white,        // نص الزر
          backgroundColor: brand,               // لون الخلفية
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: const TextStyle(color: Colors.white),
        hintStyle: TextStyle(color: Colors.grey[400]),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: brand, width: 2),
        ),
      ),
      extensions: const [
        AppColors(
          brand: brand,
          accent: Color(0xFFFFC86A),
        ),
      ],
    );
  }
}
