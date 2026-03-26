import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('ta'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Fynz - Budget & Expense Tracker'**
  String get appTitle;

  /// No description provided for @welcomeToFynz.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Fynz'**
  String get welcomeToFynz;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {userName}!'**
  String hello(String userName);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @monthlyOverview.
  ///
  /// In en, this message translates to:
  /// **'Monthly Overview'**
  String get monthlyOverview;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @spendingByCategory.
  ///
  /// In en, this message translates to:
  /// **'Spending by Category'**
  String get spendingByCategory;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @onTrack.
  ///
  /// In en, this message translates to:
  /// **'On Track'**
  String get onTrack;

  /// No description provided for @overBudget.
  ///
  /// In en, this message translates to:
  /// **'Over Budget'**
  String get overBudget;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @monthStartDay.
  ///
  /// In en, this message translates to:
  /// **'Month Start Day'**
  String get monthStartDay;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @exportCSV.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCSV;

  /// No description provided for @exportPDF.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPDF;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @license.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get license;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @personalizeExperience.
  ///
  /// In en, this message translates to:
  /// **'Personalize Your Experience'**
  String get personalizeExperience;

  /// No description provided for @selectCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select Currency'**
  String get selectCurrency;

  /// No description provided for @currencyAutoDetected.
  ///
  /// In en, this message translates to:
  /// **'Currency auto-detected'**
  String get currencyAutoDetected;

  /// No description provided for @whenMonthStart.
  ///
  /// In en, this message translates to:
  /// **'When does your month start?'**
  String get whenMonthStart;

  /// No description provided for @monthStartDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the day your billing cycle begins to track expenses accurately'**
  String get monthStartDescription;

  /// No description provided for @setMonthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Set your monthly income'**
  String get setMonthlyIncome;

  /// No description provided for @monthlyIncomeDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your income sources to help plan your budget effectively'**
  String get monthlyIncomeDescription;

  /// No description provided for @allSet.
  ///
  /// In en, this message translates to:
  /// **'All Set!'**
  String get allSet;

  /// No description provided for @allSetDescription.
  ///
  /// In en, this message translates to:
  /// **'Your profile is ready. Let\'s start tracking your expenses'**
  String get allSetDescription;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @freelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get freelance;

  /// No description provided for @investment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get investment;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @otherIncome.
  ///
  /// In en, this message translates to:
  /// **'Other Income'**
  String get otherIncome;

  /// No description provided for @foodAndDining.
  ///
  /// In en, this message translates to:
  /// **'Food & Dining'**
  String get foodAndDining;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// No description provided for @billsAndUtilities.
  ///
  /// In en, this message translates to:
  /// **'Bills & Utilities'**
  String get billsAndUtilities;

  /// No description provided for @healthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get healthcare;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @groceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get groceries;

  /// No description provided for @deleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Delete Expense'**
  String get deleteExpense;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this expense?'**
  String get confirmDelete;

  /// No description provided for @expenseDeleted.
  ///
  /// In en, this message translates to:
  /// **'Expense deleted successfully'**
  String get expenseDeleted;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @manageCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get manageCategories;

  /// No description provided for @categoriesDescription.
  ///
  /// In en, this message translates to:
  /// **'Create and manage custom expense and income categories'**
  String get categoriesDescription;

  /// No description provided for @getBudgetAlerts.
  ///
  /// In en, this message translates to:
  /// **'Get budget alerts and reminders'**
  String get getBudgetAlerts;

  /// No description provided for @enableDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Enable dark theme'**
  String get enableDarkTheme;

  /// No description provided for @customizeExperience.
  ///
  /// In en, this message translates to:
  /// **'Customize your experience'**
  String get customizeExperience;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @monthStartsOnDay.
  ///
  /// In en, this message translates to:
  /// **'Month starts on day {day}'**
  String monthStartsOnDay(int day);

  /// No description provided for @yourBillingCycle.
  ///
  /// In en, this message translates to:
  /// **'Your billing cycle will start on day {day} of each month'**
  String yourBillingCycle(int day);

  /// No description provided for @monthlyIncomeSources.
  ///
  /// In en, this message translates to:
  /// **'Monthly Income Sources'**
  String get monthlyIncomeSources;

  /// No description provided for @dayOne.
  ///
  /// In en, this message translates to:
  /// **'Day 1'**
  String get dayOne;

  /// No description provided for @dayTwentyEight.
  ///
  /// In en, this message translates to:
  /// **'Day 28'**
  String get dayTwentyEight;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @thisCurrencyWillBeUsed.
  ///
  /// In en, this message translates to:
  /// **'This currency will be used throughout the app for all transactions'**
  String get thisCurrencyWillBeUsed;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @failedToSaveProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to save profile'**
  String get failedToSaveProfile;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again'**
  String get anErrorOccurred;

  /// No description provided for @failedToDeleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete expense'**
  String get failedToDeleteExpense;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get chooseLanguage;

  /// No description provided for @selectYourCurrency.
  ///
  /// In en, this message translates to:
  /// **'Select your currency'**
  String get selectYourCurrency;

  /// No description provided for @billingCycleStart.
  ///
  /// In en, this message translates to:
  /// **'Billing Cycle Start'**
  String get billingCycleStart;

  /// No description provided for @billingCycleDescription.
  ///
  /// In en, this message translates to:
  /// **'Your expense tracking cycle resets on this day each month'**
  String get billingCycleDescription;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get day;

  /// No description provided for @nativeMobileApp.
  ///
  /// In en, this message translates to:
  /// **'Native Mobile App'**
  String get nativeMobileApp;

  /// No description provided for @fullyPrivate.
  ///
  /// In en, this message translates to:
  /// **'100% Private'**
  String get fullyPrivate;

  /// No description provided for @allDataStaysOnDevice.
  ///
  /// In en, this message translates to:
  /// **'All data stays on your device'**
  String get allDataStaysOnDevice;

  /// No description provided for @noBackend.
  ///
  /// In en, this message translates to:
  /// **'No Backend'**
  String get noBackend;

  /// No description provided for @noServerNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No server, no account needed'**
  String get noServerNoAccount;

  /// No description provided for @fullyOffline.
  ///
  /// In en, this message translates to:
  /// **'Fully Offline'**
  String get fullyOffline;

  /// No description provided for @worksWithoutInternet.
  ///
  /// In en, this message translates to:
  /// **'Works without internet'**
  String get worksWithoutInternet;

  /// No description provided for @lightningFast.
  ///
  /// In en, this message translates to:
  /// **'Lightning Fast'**
  String get lightningFast;

  /// No description provided for @instantAccessNoLoading.
  ///
  /// In en, this message translates to:
  /// **'Instant access, no loading'**
  String get instantAccessNoLoading;

  /// No description provided for @pleaseEnterYourNameToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name to continue'**
  String get pleaseEnterYourNameToContinue;

  /// No description provided for @welcomeToFynzDescription.
  ///
  /// In en, this message translates to:
  /// **'Your personal expense tracker that works 100% offline'**
  String get welcomeToFynzDescription;

  /// No description provided for @personalizeExperienceDescription.
  ///
  /// In en, this message translates to:
  /// **'Let\'s start by getting your name'**
  String get personalizeExperienceDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'ja',
    'ko',
    'pt',
    'ru',
    'ta',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
