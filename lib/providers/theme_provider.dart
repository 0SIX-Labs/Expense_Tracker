import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  Brightness get brightness => _isDarkMode ? Brightness.dark : Brightness.light;

  ThemeProvider() {
    _loadThemeFromHive();
  }

  void _loadThemeFromHive() {
    final box = Hive.box('app_settings');
    _isDarkMode = box.get('darkMode', defaultValue: false);
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    final box = Hive.box('app_settings');
    box.put('darkMode', _isDarkMode);
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF667eea),
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
      titleLarge: TextStyle(color: Colors.black87),
      titleMedium: TextStyle(color: Colors.black87),
    ),
  );

  ThemeData get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF667eea),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
    ),
  );
}
