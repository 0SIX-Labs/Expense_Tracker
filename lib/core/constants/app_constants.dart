/// Application-wide constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();

  // Hive Box Names
  static const String boxAppSettings = 'app_settings';
  static const String boxExpenses = 'expenses';
  static const String boxBudgets = 'budgets';
  static const String boxCategories = 'categories';
  static const String boxUserProfile = 'user_profile';
  static const String boxIncomes = 'incomes';
  static const String boxCustomCategories = 'custom_categories';

  // Hive Keys
  static const String keyDarkMode = 'darkMode';
  static const String keyCurrency = 'currency';
  static const String keyHasCompletedOnboarding = 'hasCompletedOnboarding';
  static const String keyLastSyncDate = 'lastSyncDate';
  static const String keyMonthStartDay = 'monthStartDay';
  static const String keyUserName = 'userName';
  static const String keyUserProfileId = 'userProfileId';

  // Default Values
  static const String defaultCurrency = 'USD';
  static const double defaultBudgetAmount = 500.00;

  // Date Formats
  static const String dateFormatDisplay = 'MMM dd, yyyy';
  static const String dateFormatCompact = 'MMM dd';
  static const String dateFormatIso = 'yyyy-MM-dd';

  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Pagination
  static const int pageSize = 20;
  static const int maxRecentExpenses = 10;

  // Budget Thresholds
  static const double budgetWarningThreshold = 0.8; // 80%
  static const double budgetDangerThreshold = 0.95; // 95%

  // Export
  static const String exportDateFormat = 'yyyy-MM-dd_HH-mm-ss';
}
