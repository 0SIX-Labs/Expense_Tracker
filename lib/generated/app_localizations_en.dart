// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fynz - Budget & Expense Tracker';

  @override
  String get welcomeToFynz => 'Welcome to Fynz';

  @override
  String hello(String userName) {
    return 'Hello, $userName!';
  }

  @override
  String get settings => 'Settings';

  @override
  String get home => 'Home';

  @override
  String get analytics => 'Analytics';

  @override
  String get budget => 'Budget';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get monthlyOverview => 'Monthly Overview';

  @override
  String get income => 'Income';

  @override
  String get spent => 'Spent';

  @override
  String get remaining => 'Remaining';

  @override
  String get thisMonth => 'This Month';

  @override
  String get thisWeek => 'This Week';

  @override
  String get spendingByCategory => 'Spending by Category';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get seeAll => 'See All';

  @override
  String get onTrack => 'On Track';

  @override
  String get overBudget => 'Over Budget';

  @override
  String get categories => 'Categories';

  @override
  String get currency => 'Currency';

  @override
  String get monthStartDay => 'Month Start Day';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get notifications => 'Notifications';

  @override
  String get exportData => 'Export Data';

  @override
  String get exportCSV => 'Export CSV';

  @override
  String get exportPDF => 'Export PDF';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get developer => 'Developer';

  @override
  String get license => 'License';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get yourName => 'Your Name';

  @override
  String get personalizeExperience => 'Personalize Your Experience';

  @override
  String get selectCurrency => 'Select Currency';

  @override
  String get currencyAutoDetected => 'Currency auto-detected';

  @override
  String get whenMonthStart => 'When does your month start?';

  @override
  String get monthStartDescription =>
      'Choose the day your billing cycle begins to track expenses accurately';

  @override
  String get setMonthlyIncome => 'Set your monthly income';

  @override
  String get monthlyIncomeDescription =>
      'Enter your income sources to help plan your budget effectively';

  @override
  String get allSet => 'All Set!';

  @override
  String get allSetDescription =>
      'Your profile is ready. Let\'s start tracking your expenses';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get salary => 'Salary';

  @override
  String get freelance => 'Freelance';

  @override
  String get investment => 'Investment';

  @override
  String get other => 'Other';

  @override
  String get otherIncome => 'Other Income';

  @override
  String get foodAndDining => 'Food & Dining';

  @override
  String get transport => 'Transport';

  @override
  String get shopping => 'Shopping';

  @override
  String get entertainment => 'Entertainment';

  @override
  String get billsAndUtilities => 'Bills & Utilities';

  @override
  String get healthcare => 'Healthcare';

  @override
  String get education => 'Education';

  @override
  String get travel => 'Travel';

  @override
  String get groceries => 'Groceries';

  @override
  String get deleteExpense => 'Delete Expense';

  @override
  String get confirmDelete => 'Are you sure you want to delete this expense?';

  @override
  String get expenseDeleted => 'Expense deleted successfully';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get manageCategories => 'Manage Categories';

  @override
  String get categoriesDescription =>
      'Create and manage custom expense and income categories';

  @override
  String get getBudgetAlerts => 'Get budget alerts and reminders';

  @override
  String get enableDarkTheme => 'Enable dark theme';

  @override
  String get customizeExperience => 'Customize your experience';

  @override
  String get profile => 'Profile';

  @override
  String monthStartsOnDay(int day) {
    return 'Month starts on day $day';
  }

  @override
  String yourBillingCycle(int day) {
    return 'Your billing cycle will start on day $day of each month';
  }

  @override
  String get monthlyIncomeSources => 'Monthly Income Sources';

  @override
  String get dayOne => 'Day 1';

  @override
  String get dayTwentyEight => 'Day 28';

  @override
  String get selected => 'Selected';

  @override
  String get thisCurrencyWillBeUsed =>
      'This currency will be used throughout the app for all transactions';

  @override
  String get pleaseEnterYourName => 'Please enter your name';

  @override
  String get failedToSaveProfile => 'Failed to save profile';

  @override
  String get anErrorOccurred => 'An error occurred. Please try again';

  @override
  String get failedToDeleteExpense => 'Failed to delete expense';
}
