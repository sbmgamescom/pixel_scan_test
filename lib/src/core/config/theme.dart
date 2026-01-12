import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Конфигурация темы приложения с использованием shadcn_ui
class AppTheme {
  // Основные цвета приложения
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color destructiveRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF22C55E);
  static const Color warningOrange = Color(0xFFF97316);

  /// Светлая тема
  static ShadThemeData get lightTheme => ShadThemeData(
        brightness: Brightness.light,
      );

  /// Тёмная тема
  static ShadThemeData get darkTheme => ShadThemeData(
        brightness: Brightness.dark,
      );

  /// Градиент для Premium элементов
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Градиент для кнопок действий
  static const LinearGradient actionGradient = LinearGradient(
    colors: [primaryBlue, Color(0xFF2563EB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
