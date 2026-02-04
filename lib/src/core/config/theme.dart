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

  // Text Styles (Unified Typography)
  static const TextStyle headerStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const TextStyle subheaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  /// Светлая тема
  static ShadThemeData get lightTheme => ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadSlateColorScheme.light(
          primary: primaryBlue,
        ),
        textTheme: ShadTextTheme(
          h1: headerStyle.copyWith(fontSize: 30),
          h2: headerStyle,
          h3: subheaderStyle,
          h4: subheaderStyle.copyWith(fontSize: 16),
          p: bodyStyle,
          muted: captionStyle,
        ),
        radius: BorderRadius.circular(12),
      );

  /// Тёмная тема
  static ShadThemeData get darkTheme => ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadSlateColorScheme.dark(
          primary: primaryBlue,
        ),
        textTheme: ShadTextTheme(
          h1: headerStyle.copyWith(fontSize: 30, color: Colors.white),
          h2: headerStyle.copyWith(color: Colors.white),
          h3: subheaderStyle.copyWith(color: Colors.white),
          h4: subheaderStyle.copyWith(fontSize: 16, color: Colors.white),
          p: bodyStyle.copyWith(color: Colors.white),
          muted: captionStyle,
        ),
        radius: BorderRadius.circular(12),
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
