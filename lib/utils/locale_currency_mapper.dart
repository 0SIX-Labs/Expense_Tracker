import 'dart:ui';

/// Utility class for mapping device locale to currency
class LocaleCurrencyMapper {
  /// Map country codes to currency codes
  static const Map<String, String> countryToCurrency = {
    // Americas
    'US': 'USD', // United States
    'CA': 'CAD', // Canada
    'MX': 'MXN', // Mexico
    'BR': 'BRL', // Brazil
    'AR': 'ARS', // Argentina
    'CL': 'CLP', // Chile
    'CO': 'COP', // Colombia
    'PE': 'PEN', // Peru
    // Europe
    'DE': 'EUR', // Germany
    'FR': 'EUR', // France
    'ES': 'EUR', // Spain
    'IT': 'EUR', // Italy
    'PT': 'EUR', // Portugal
    'NL': 'EUR', // Netherlands
    'BE': 'EUR', // Belgium
    'AT': 'EUR', // Austria
    'IE': 'EUR', // Ireland
    'FI': 'EUR', // Finland
    'GR': 'EUR', // Greece
    'GB': 'GBP', // United Kingdom
    'CH': 'CHF', // Switzerland
    'SE': 'SEK', // Sweden
    'NO': 'NOK', // Norway
    'DK': 'DKK', // Denmark
    'PL': 'PLN', // Poland
    'CZ': 'CZK', // Czech Republic
    'HU': 'HUF', // Hungary
    'RO': 'RON', // Romania
    'BG': 'BGN', // Bulgaria
    'HR': 'HRK', // Croatia
    'RS': 'RSD', // Serbia
    'UA': 'UAH', // Ukraine
    'RU': 'RUB', // Russia
    // Asia Pacific
    'JP': 'JPY', // Japan
    'CN': 'CNY', // China
    'KR': 'KRW', // South Korea
    'IN': 'INR', // India
    'AU': 'AUD', // Australia
    'NZ': 'NZD', // New Zealand
    'SG': 'SGD', // Singapore
    'HK': 'HKD', // Hong Kong
    'TW': 'TWD', // Taiwan
    'TH': 'THB', // Thailand
    'MY': 'MYR', // Malaysia
    'ID': 'IDR', // Indonesia
    'PH': 'PHP', // Philippines
    'VN': 'VND', // Vietnam
    'PK': 'PKR', // Pakistan
    'BD': 'BDT', // Bangladesh
    'LK': 'LKR', // Sri Lanka
    // Middle East & Africa
    'AE': 'AED', // UAE
    'SA': 'SAR', // Saudi Arabia
    'QA': 'QAR', // Qatar
    'KW': 'KWD', // Kuwait
    'BH': 'BHD', // Bahrain
    'OM': 'OMR', // Oman
    'IL': 'ILS', // Israel
    'TR': 'TRY', // Turkey
    'ZA': 'ZAR', // South Africa
    'EG': 'EGP', // Egypt
    'NG': 'NGN', // Nigeria
    'KE': 'KES', // Kenya
    'GH': 'GHS', // Ghana
    'MA': 'MAD', // Morocco
    'TN': 'TND', // Tunisia
  };

  /// Get currency code from device locale
  static String getCurrencyFromLocale() {
    final locale = PlatformDispatcher.instance.locale;
    final countryCode = locale.countryCode;

    if (countryCode != null && countryToCurrency.containsKey(countryCode)) {
      return countryToCurrency[countryCode]!;
    }

    // Fallback: try to infer from language code
    return _getCurrencyFromLanguage(locale.languageCode);
  }

  /// Fallback: infer currency from language
  static String _getCurrencyFromLanguage(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'USD'; // Default for English
      case 'es':
        return 'EUR'; // Spanish → Euro (Spain)
      case 'de':
        return 'EUR'; // German → Euro (Germany)
      case 'fr':
        return 'EUR'; // French → Euro (France)
      case 'pt':
        return 'BRL'; // Portuguese → Brazilian Real
      case 'ja':
        return 'JPY'; // Japanese → Yen
      case 'zh':
        return 'CNY'; // Chinese → Yuan
      case 'ko':
        return 'KRW'; // Korean → Won
      case 'ar':
        return 'SAR'; // Arabic → Saudi Riyal
      case 'ru':
        return 'RUB'; // Russian → Ruble
      case 'tr':
        return 'TRY'; // Turkish → Lira
      case 'pl':
        return 'PLN'; // Polish → Zloty
      case 'cs':
        return 'CZK'; // Czech → Koruna
      case 'hu':
        return 'HUF'; // Hungarian → Forint
      case 'ro':
        return 'RON'; // Romanian → Leu
      case 'bg':
        return 'BGN'; // Bulgarian → Lev
      case 'hr':
        return 'HRK'; // Croatian → Kuna
      case 'uk':
        return 'UAH'; // Ukrainian → Hryvnia
      default:
        return 'USD'; // Ultimate fallback
    }
  }

  /// Get the device locale string
  static String getDeviceLocale() {
    final locale = PlatformDispatcher.instance.locale;
    return '${locale.languageCode}_${locale.countryCode ?? locale.languageCode.toUpperCase()}';
  }

  /// Get the device language code
  static String getDeviceLanguage() {
    return PlatformDispatcher.instance.locale.languageCode;
  }

  /// Check if device is using a specific language
  static bool isLanguage(String languageCode) {
    return PlatformDispatcher.instance.locale.languageCode == languageCode;
  }

  /// Get currency symbol from currency code
  static String getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'CNY':
        return '¥';
      case 'KRW':
        return '₩';
      case 'INR':
        return '₹';
      case 'RUB':
        return '₽';
      case 'BRL':
        return 'R\$';
      case 'CAD':
        return 'C\$';
      case 'AUD':
        return 'A\$';
      case 'CHF':
        return 'CHF';
      case 'SEK':
        return 'kr';
      case 'NOK':
        return 'kr';
      case 'DKK':
        return 'kr';
      case 'PLN':
        return 'zł';
      case 'CZK':
        return 'Kč';
      case 'HUF':
        return 'Ft';
      case 'RON':
        return 'lei';
      case 'TRY':
        return '₺';
      case 'ZAR':
        return 'R';
      case 'AED':
        return 'د.إ';
      case 'SAR':
        return 'ر.س';
      case 'THB':
        return '฿';
      case 'MYR':
        return 'RM';
      case 'SGD':
        return 'S\$';
      case 'HKD':
        return 'HK\$';
      case 'TWD':
        return 'NT\$';
      case 'PHP':
        return '₱';
      case 'IDR':
        return 'Rp';
      case 'VND':
        return '₫';
      case 'MXN':
        return '\$';
      case 'ARS':
        return '\$';
      case 'CLP':
        return '\$';
      case 'COP':
        return '\$';
      case 'PEN':
        return 'S/.';
      default:
        return currencyCode;
    }
  }
}
