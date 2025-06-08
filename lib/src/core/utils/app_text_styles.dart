import 'package:flutter/material.dart';

class AppTextStyles {
  // SF Pro Display - используем статические шрифты
  static const String _fontFamily = 'SF Pro Display';

  // Заголовки
  static const TextStyle title1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w700, // Bold
    height: 1.1,
  );

  static const TextStyle title2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700, // Bold
    height: 1.2,
  );

  static const TextStyle title3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600, // Semibold
    height: 1.3,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600, // Semibold
    height: 1.3,
  );

  // Основной текст
  static const TextStyle body1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400, // Regular
    height: 1.4,
  );

  static const TextStyle body2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    height: 1.3,
  );

  static const TextStyle small = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    height: 1.2,
  );

  // Кнопки
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600, // Semibold
    height: 1.2,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600, // Semibold
    height: 1.2,
  );

  // Цветные варианты
  static TextStyle primaryColor(TextStyle base) => base.copyWith(
        color: const Color(0xFFE53E3E),
      );

  static TextStyle secondaryColor(TextStyle base) => base.copyWith(
        color: Colors.grey[600],
      );

  static TextStyle whiteColor(TextStyle base) => base.copyWith(
        color: Colors.white,
      );

  static TextStyle blackColor(TextStyle base) => base.copyWith(
        color: Colors.black,
      );
}
