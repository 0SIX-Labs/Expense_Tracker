import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum AppTheme { glass, material, mint }

class ThemeProvider extends ChangeNotifier {
  AppTheme _currentTheme = AppTheme.glass;

  AppTheme get currentTheme => _currentTheme;

  ThemeProvider() {
    _loadThemeFromHive();
  }

  void _loadThemeFromHive() {
    final box = Hive.box('app_settings');
    final themeValue = box.get('appTheme', defaultValue: 'glass');
    _currentTheme = AppTheme.values.firstWhere(
      (e) => e.toString() == 'AppTheme.$themeValue',
      orElse: () => AppTheme.glass,
    );
    notifyListeners();
  }

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    final box = Hive.box('app_settings');
    box.put('appTheme', theme.toString().split('.').last);
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

  ThemeData get themeData => lightTheme;

  ThemeData get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF667eea),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: const Color(0xFF121212),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white70),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
    ),
  );

  bool get isDarkMode => false; // Default to light mode

  // Theme color definitions
  List<Color> get primaryGradient {
    switch (_currentTheme) {
      case AppTheme.glass:
        return const [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)];
      case AppTheme.material:
        return const [Color(0xFF667eea), Color(0xFF764ba2)];
      case AppTheme.mint:
        return const [Color(0xFF1DB584), Color(0xFF00D4A1)];
    }
  }

  Color get cardBackgroundColor {
    switch (_currentTheme) {
      case AppTheme.glass:
        return Colors.white.withValues(alpha: 0.1);
      case AppTheme.material:
        return const Color(0xFFF5F5F5);
      case AppTheme.mint:
        return Colors.white;
    }
  }

  Color get cardBorderColor {
    switch (_currentTheme) {
      case AppTheme.glass:
        return Colors.white.withValues(alpha: 0.2);
      case AppTheme.material:
        return Colors.grey[300]!;
      case AppTheme.mint:
        return const Color(0xFFE0F2F1);
    }
  }

  double get cardBlurSigma {
    switch (_currentTheme) {
      case AppTheme.glass:
        return 20;
      case AppTheme.material:
        return 0;
      case AppTheme.mint:
        return 0;
    }
  }

  double get cardBackgroundOpacity {
    switch (_currentTheme) {
      case AppTheme.glass:
        return 0.1;
      case AppTheme.material:
        return 1;
      case AppTheme.mint:
        return 1;
    }
  }

  String get themeName {
    switch (_currentTheme) {
      case AppTheme.glass:
        return 'Glass Morphism';
      case AppTheme.material:
        return 'Material Design';
      case AppTheme.mint:
        return 'Mint & White';
    }
  }
}
