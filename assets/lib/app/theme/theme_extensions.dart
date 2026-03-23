import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color brand;
  final Color accent;

  const AppColors({required this.brand, required this.accent});

  @override
  AppColors copyWith({Color? brand, Color? accent}) =>
      AppColors(brand: brand ?? this.brand, accent: accent ?? this.accent);

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      brand: Color.lerp(brand, other.brand, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}
