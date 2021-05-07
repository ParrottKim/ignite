import 'package:flutter/material.dart';

const MaterialColor mainColors =
    const MaterialColor(0xFFFF0000, const <int, Color>{
  50: const Color(0xFFFFE7E6),
  100: const Color(0xFFFFC7B8),
  200: const Color(0xFFFFA28A),
  300: const Color(0xFFFF795B),
  400: const Color(0xFFFF5436),
  500: const Color(0xFFFF200C),
  600: const Color(0xFFFF1507),
  700: const Color(0xFFFF0000),
  800: const Color(0xFFF10000),
  900: const Color(0xFFDA0000),
});

class MainTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'SCDream',
      brightness: Brightness.light,
      primarySwatch: mainColors,
      primaryColor: mainColors,
      accentColor: mainColors[900],
      backgroundColor: Colors.white,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.red[900],
        unselectedItemColor: Colors.red[100],
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: mainColors,
          foregroundColor: mainColors,
          brightness: Brightness.dark),
    );
  }
}
