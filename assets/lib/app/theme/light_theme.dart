import 'package:flutter/material.dart';
import 'theme_extensions.dart';

class LightTheme {
  static ThemeData build(TextTheme baseText) {
    const brand = Color(0xFFF4A300); // matches your figma orange
    final cs = ColorScheme.fromSeed(seedColor: brand, brightness: Brightness.light);

    return ThemeData(
      colorScheme: cs,
      useMaterial3: true,
      textTheme: baseText,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      appBarTheme: const AppBarTheme(centerTitle: true),
      extensions: const [AppColors(brand: brand, accent: Color(0xFFFFC86A))],
    );
  }
}
