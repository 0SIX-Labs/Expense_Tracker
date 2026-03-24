import 'package:intl/intl.dart';
import '../services/user_profile_service.dart';
import '../core/constants/app_constants.dart';
import 'locale_currency_mapper.dart';

/// Utility class for currency formatting and management
class CurrencyUtils {
  /// Get suggested currency based on device locale
  static String getSuggestedCurrency() {
    return LocaleCurrencyMapper.getCurrencyFromLocale();
  }

  /// Check if user's currency matches device locale
  static Future<bool> isCurrencyMatchingLocale() async {
    final userCurrency = await getCurrencyCode();
    final deviceCurrency = getSuggestedCurrency();
    return userCurrency == deviceCurrency;
  }

  /// Get currency symbol using locale mapper
  static String getCurrencySymbolFromCode(String currencyCode) {
    return LocaleCurrencyMapper.getCurrencySymbol(currencyCode);
  }

  /// Get the user's selected currency symbol
  static Future<String> getCurrencySymbol() async {
    try {
      final profileResult = await UserProfileService().get();
      if (profileResult.isSuccess && profileResult.data != null) {
        final currency = profileResult.data!.defaultCurrency;
        return _getCurrencySymbolFromCode(currency);
      }
    } catch (e) {
      // Fallback to default currency
    }
    return _getCurrencySymbolFromCode(AppConstants.defaultCurrency);
  }

  /// Get the user's selected currency code
  static Future<String> getCurrencyCode() async {
    try {
      final profileResult = await UserProfileService().get();
      if (profileResult.isSuccess && profileResult.data != null) {
        return profileResult.data!.defaultCurrency;
      }
    } catch (e) {
      // Fallback to default currency
    }
    return AppConstants.defaultCurrency;
  }

  /// Create a NumberFormat instance with the user's currency
  static Future<NumberFormat> getCurrencyFormatter() async {
    final currencyCode = await getCurrencyCode();
    return NumberFormat.currency(
      locale: _getLocaleFromCurrencyCode(currencyCode),
      name: currencyCode,
    );
  }

  /// Get currency symbol from currency code
  static String _getCurrencySymbolFromCode(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'CAD':
        return 'C\$';
      case 'AUD':
        return 'A\$';
      case 'CHF':
        return 'CHF';
      case 'CNY':
        return '¥';
      case 'INR':
        return '₹';
      case 'BRL':
        return 'R\$';
      default:
        return currencyCode;
    }
  }

  /// Get locale from currency code for NumberFormat
  static String _getLocaleFromCurrencyCode(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return 'en_US';
      case 'EUR':
        return 'de_DE';
      case 'GBP':
        return 'en_GB';
      case 'JPY':
        return 'ja_JP';
      case 'CAD':
        return 'en_CA';
      case 'AUD':
        return 'en_AU';
      case 'CHF':
        return 'de_CH';
      case 'CNY':
        return 'zh_CN';
      case 'INR':
        return 'en_IN';
      case 'BRL':
        return 'pt_BR';
      default:
        return 'en_US';
    }
  }
}
