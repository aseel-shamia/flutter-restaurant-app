import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/state/theme_notifier.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  /// القيمة الأساسية
  ThemeMode get themeMode => _themeMode;

  /// alias للاسم القديم (mode)
  ThemeMode get mode => _themeMode;

  /// هل الوضع الحالي داكن؟
  bool get isDark => _themeMode == ThemeMode.dark;

  /// تغيير الثيم مباشرة
  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  /// تبديل بين داكن / مضيء
  void toggleTheme() {
    _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  /// alias للاسم القديم (toggle)
  void toggle() => toggleTheme();
}
