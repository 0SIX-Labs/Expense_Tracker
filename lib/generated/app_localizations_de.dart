// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Fynz - Budget & Ausgaben';

  @override
  String get welcomeToFynz => 'Willkommen bei Fynz';

  @override
  String hello(String userName) {
    return 'Hallo, $userName!';
  }

  @override
  String get settings => 'Einstellungen';

  @override
  String get home => 'Startseite';

  @override
  String get analytics => 'Analytik';

  @override
  String get budget => 'Budget';

  @override
  String get addExpense => 'Ausgabe hinzufügen';

  @override
  String get monthlyOverview => 'Monatsübersicht';

  @override
  String get income => 'Einkommen';

  @override
  String get spent => 'Ausgegeben';

  @override
  String get remaining => 'Verbleibend';

  @override
  String get thisMonth => 'Dieser Monat';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get spendingByCategory => 'Ausgaben nach Kategorie';

  @override
  String get recentTransactions => 'Letzte Transaktionen';

  @override
  String get seeAll => 'Alle anzeigen';

  @override
  String get onTrack => 'Im Rahmen';

  @override
  String get overBudget => 'Über Budget';

  @override
  String get categories => 'Kategorien';

  @override
  String get currency => 'Währung';

  @override
  String get monthStartDay => 'Monatsstarttag';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get exportData => 'Daten exportieren';

  @override
  String get exportCSV => 'CSV exportieren';

  @override
  String get exportPDF => 'PDF exportieren';

  @override
  String get about => 'Über';

  @override
  String get version => 'Version';

  @override
  String get developer => 'Entwickler';

  @override
  String get license => 'Lizenz';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get save => 'Speichern';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get yourName => 'Dein Name';

  @override
  String get personalizeExperience => 'Personalisiere deine Erfahrung';

  @override
  String get selectCurrency => 'Währung auswählen';

  @override
  String get currencyAutoDetected => 'Währung automatisch erkannt';

  @override
  String get whenMonthStart => 'Wann beginnt dein Monat?';

  @override
  String get monthStartDescription =>
      'Wähle den Tag, an dem dein Abrechnungszyklus beginnt, um Ausgaben genau zu verfolgen';

  @override
  String get setMonthlyIncome => 'Lege dein monatliches Einkommen fest';

  @override
  String get monthlyIncomeDescription =>
      'Gib deine Einkommensquellen ein, um dein Budget effektiv zu planen';

  @override
  String get allSet => 'Alles bereit!';

  @override
  String get allSetDescription =>
      'Dein Profil ist bereit. Lass uns mit der Ausgabenverfolgung beginnen';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get next => 'Weiter';

  @override
  String get skip => 'Überspringen';

  @override
  String get salary => 'Gehalt';

  @override
  String get freelance => 'Freiberuflich';

  @override
  String get investment => 'Investition';

  @override
  String get other => 'Andere';

  @override
  String get otherIncome => 'Sonstiges Einkommen';

  @override
  String get foodAndDining => 'Essen & Gastronomie';

  @override
  String get transport => 'Transport';

  @override
  String get shopping => 'Einkaufen';

  @override
  String get entertainment => 'Unterhaltung';

  @override
  String get billsAndUtilities => 'Rechnungen & Versorgung';

  @override
  String get healthcare => 'Gesundheit';

  @override
  String get education => 'Bildung';

  @override
  String get travel => 'Reisen';

  @override
  String get groceries => 'Lebensmittel';

  @override
  String get deleteExpense => 'Ausgabe löschen';

  @override
  String get confirmDelete =>
      'Bist du sicher, dass du diese Ausgabe löschen möchtest?';

  @override
  String get expenseDeleted => 'Ausgabe erfolgreich gelöscht';

  @override
  String get profileUpdated => 'Profil erfolgreich aktualisiert';

  @override
  String get manageCategories => 'Kategorien verwalten';

  @override
  String get categoriesDescription =>
      'Erstelle und verwalte benutzerdefinierte Ausgaben- und Einkommenskategorien';

  @override
  String get getBudgetAlerts =>
      'Budget-Benachrichtigungen und Erinnerungen erhalten';

  @override
  String get enableDarkTheme => 'Dunkles Theme aktivieren';

  @override
  String get customizeExperience => 'Passe deine Erfahrung an';

  @override
  String get profile => 'Profil';

  @override
  String monthStartsOnDay(int day) {
    return 'Monat beginnt am Tag $day';
  }

  @override
  String yourBillingCycle(int day) {
    return 'Dein Abrechnungszyklus beginnt am $day. jedes Monats';
  }

  @override
  String get monthlyIncomeSources => 'Monatliche Einkommensquellen';

  @override
  String get dayOne => 'Tag 1';

  @override
  String get dayTwentyEight => 'Tag 28';

  @override
  String get selected => 'Ausgewählt';

  @override
  String get thisCurrencyWillBeUsed =>
      'Diese Währung wird in der gesamten App für alle Transaktionen verwendet';

  @override
  String get pleaseEnterYourName => 'Bitte gib deinen Namen ein';

  @override
  String get failedToSaveProfile => 'Profil konnte nicht gespeichert werden';

  @override
  String get anErrorOccurred =>
      'Ein Fehler ist aufgetreten. Bitte versuche es erneut';

  @override
  String get failedToDeleteExpense => 'Ausgabe konnte nicht gelöscht werden';
}
