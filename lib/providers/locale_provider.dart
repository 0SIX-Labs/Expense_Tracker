import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../core/core.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  void _loadLocale() {
    try {
      final box = Hive.box(AppConstants.boxAppSettings);
      final savedLanguage = box.get('selectedLanguage', defaultValue: 'en');
      _locale = Locale(savedLanguage);
      notifyListeners();
    } catch (e) {
      // If there's an error, use default locale
      _locale = const Locale('en');
    }
  }

  Future<void> setLocale(String languageCode) async {
    _locale = Locale(languageCode);

    // Save to Hive
    try {
      final box = Hive.box(AppConstants.boxAppSettings);
      await box.put('selectedLanguage', languageCode);
    } catch (e) {
      // If saving fails, still update the locale
    }

    notifyListeners();
  }

  // Helper method to get display name for language
  static String getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇬🇧 English';
      case 'es':
        return '🇪🇸 Español';
      case 'de':
        return '🇩🇪 Deutsch';
      case 'fr':
        return '🇫🇷 Français';
      case 'pt':
        return '🇵🇹 Português';
      case 'ja':
        return '🇯🇵 日本語';
      case 'ko':
        return '🇰🇷 한국어';
      case 'ru':
        return '🇷🇺 Русский';
      default:
        return languageCode.toUpperCase();
    }
  }

  // Get list of supported languages
  static List<String> get supportedLanguages => [
    'en',
    'es',
    'de',
    'fr',
    'pt',
    'ja',
    'ko',
    'ru',
  ];
}
