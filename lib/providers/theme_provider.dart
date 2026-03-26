import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

<<<<<<< Updated upstream
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
=======
enum AppTheme { glass }

class ThemeProvider extends ChangeNotifier {
  // Keep only Glass theme - removed material and mint themes
  AppTheme _currentTheme = AppTheme.glass;
>>>>>>> Stashed changes

  bool get isDarkMode => _isDarkMode;
  Brightness get brightness => _isDarkMode ? Brightness.dark : Brightness.light;

  ThemeProvider() {
<<<<<<< Updated upstream
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
=======
    // Initialize with Glass theme only
    _currentTheme = AppTheme.glass;
    notifyListeners();
  }

  // Removed _loadThemeFromHive() and setTheme() methods since we only have one theme

  // Removed lightTheme, darkTheme, and isDarkMode since we only use Glass theme

  // Theme color definitions
  List<Color> get primaryGradient {
    // Only Glass theme - simplified for single theme
    return const [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)];
  }

  Color get cardBackgroundColor {
    // Only Glass theme - simplified for single theme
    return Colors.white.withValues(alpha: 0.1);
  }

  Color get cardBorderColor {
    // Only Glass theme - simplified for single theme
    return Colors.white.withValues(alpha: 0.2);
  }

  double get cardBlurSigma {
    // Only Glass theme - simplified for single theme
    return 20;
  }

  double get cardBackgroundOpacity {
    // Only Glass theme - simplified for single theme
    return 0.1;
  }

  String get themeName {
    // Only Glass theme - simplified for single theme
    return 'Glass Morphism';
  }
>>>>>>> Stashed changes
}
