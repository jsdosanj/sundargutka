import 'package:flutter/material.dart';

class AppTheme {
  static const Color accentOrange = Color(0xFFFF8C00);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color sepiaBackground = Color(0xFFF5E6C8);
  static const Color sepiaText = Color(0xFF4A3728);
  static const Color sepiaSurface = Color(0xFFEDD9A3);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentOrange,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: const CardTheme(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    dividerTheme: const DividerThemeData(space: 1),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentOrange,
      foregroundColor: Colors.white,
    ),
  );

  static ThemeData get sepiaTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentOrange,
      brightness: Brightness.light,
      surface: sepiaBackground,
    ).copyWith(surface: sepiaBackground, onSurface: sepiaText),
    scaffoldBackgroundColor: sepiaBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: sepiaSurface,
      foregroundColor: sepiaText,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: const CardTheme(
      elevation: 1,
      color: sepiaSurface,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: sepiaText),
      bodyMedium: TextStyle(color: sepiaText),
      titleLarge: TextStyle(color: sepiaText),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentOrange,
      foregroundColor: Colors.white,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentOrange,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: const CardTheme(
      elevation: 1,
      color: Color(0xFF1E1E1E),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accentOrange,
      foregroundColor: Colors.white,
    ),
  );
}
