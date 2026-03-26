// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Fynz - Budget & Dépenses';

  @override
  String get welcomeToFynz => 'Bienvenue sur Fynz';

  @override
  String hello(String userName) {
    return 'Bonjour, $userName !';
  }

  @override
  String get settings => 'Paramètres';

  @override
  String get home => 'Accueil';

  @override
  String get analytics => 'Analytique';

  @override
  String get budget => 'Budget';

  @override
  String get addExpense => 'Ajouter une dépense';

  @override
  String get monthlyOverview => 'Aperçu mensuel';

  @override
  String get income => 'Revenus';

  @override
  String get spent => 'Dépensé';

  @override
  String get remaining => 'Restant';

  @override
  String get thisMonth => 'Ce mois';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get spendingByCategory => 'Dépenses par catégorie';

  @override
  String get recentTransactions => 'Transactions récentes';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get onTrack => 'En bonne voie';

  @override
  String get overBudget => 'Dépassé le budget';

  @override
  String get categories => 'Catégories';

  @override
  String get currency => 'Devise';

  @override
  String get monthStartDay => 'Jour de début du mois';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get notifications => 'Notifications';

  @override
  String get exportData => 'Exporter les données';

  @override
  String get exportCSV => 'Exporter CSV';

  @override
  String get exportPDF => 'Exporter PDF';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get developer => 'Développeur';

  @override
  String get license => 'Licence';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get save => 'Enregistrer';

  @override
  String get edit => 'Modifier';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get yourName => 'Votre nom';

  @override
  String get personalizeExperience => 'Personnalisez votre expérience';

  @override
  String get selectCurrency => 'Sélectionner la devise';

  @override
  String get currencyAutoDetected => 'Devise détectée automatiquement';

  @override
  String get whenMonthStart => 'Quand commence votre mois ?';

  @override
  String get monthStartDescription =>
      'Choisissez le jour de début de votre cycle de facturation pour suivre les dépenses avec précision';

  @override
  String get setMonthlyIncome => 'Définissez vos revenus mensuels';

  @override
  String get monthlyIncomeDescription =>
      'Entrez vos sources de revenus pour aider à planifier votre budget efficacement';

  @override
  String get allSet => 'Tout est prêt !';

  @override
  String get allSetDescription =>
      'Votre profil est prêt. Commençons à suivre vos dépenses';

  @override
  String get getStarted => 'Commencer';

  @override
  String get next => 'Suivant';

  @override
  String get skip => 'Passer';

  @override
  String get salary => 'Salaire';

  @override
  String get freelance => 'Freelance';

  @override
  String get investment => 'Investissement';

  @override
  String get other => 'Autre';

  @override
  String get otherIncome => 'Autres revenus';

  @override
  String get foodAndDining => 'Alimentation & Restaurants';

  @override
  String get transport => 'Transport';

  @override
  String get shopping => 'Shopping';

  @override
  String get entertainment => 'Divertissement';

  @override
  String get billsAndUtilities => 'Factures & Services';

  @override
  String get healthcare => 'Santé';

  @override
  String get education => 'Éducation';

  @override
  String get travel => 'Voyages';

  @override
  String get groceries => 'Épicerie';

  @override
  String get deleteExpense => 'Supprimer la dépense';

  @override
  String get confirmDelete =>
      'Êtes-vous sûr de vouloir supprimer cette dépense ?';

  @override
  String get expenseDeleted => 'Dépense supprimée avec succès';

  @override
  String get profileUpdated => 'Profil mis à jour avec succès';

  @override
  String get manageCategories => 'Gérer les catégories';

  @override
  String get categoriesDescription =>
      'Créez et gérez des catégories personnalisées de dépenses et de revenus';

  @override
  String get getBudgetAlerts => 'Recevoir des alertes et rappels de budget';

  @override
  String get enableDarkTheme => 'Activer le thème sombre';

  @override
  String get customizeExperience => 'Personnalisez votre expérience';

  @override
  String get profile => 'Profil';

  @override
  String monthStartsOnDay(int day) {
    return 'Le mois commence le jour $day';
  }

  @override
  String yourBillingCycle(int day) {
    return 'Votre cycle de facturation commencera le $day de chaque mois';
  }

  @override
  String get monthlyIncomeSources => 'Sources de revenus mensuels';

  @override
  String get dayOne => 'Jour 1';

  @override
  String get dayTwentyEight => 'Jour 28';

  @override
  String get selected => 'Sélectionné';

  @override
  String get thisCurrencyWillBeUsed =>
      'Cette devise sera utilisée dans toute l\'application pour toutes les transactions';

  @override
  String get pleaseEnterYourName => 'Veuillez entrer votre nom';

  @override
  String get failedToSaveProfile => 'Échec de l\'enregistrement du profil';

  @override
  String get anErrorOccurred =>
      'Une erreur s\'est produite. Veuillez réessayer';

  @override
  String get failedToDeleteExpense => 'Échec de la suppression de la dépense';

  @override
  String get language => 'Langue';

  @override
  String get chooseLanguage => 'Choisissez votre langue préférée';

  @override
  String get selectYourCurrency => 'Sélectionnez votre devise';

  @override
  String get billingCycleStart => 'Début du cycle de facturation';

  @override
  String get billingCycleDescription =>
      'Votre cycle de suivi des dépenses se réinitialise ce jour chaque mois';

  @override
  String get day => 'Jour';

  @override
  String get nativeMobileApp => 'Application mobile native';

  @override
  String get fullyPrivate => '100% Privé';

  @override
  String get allDataStaysOnDevice =>
      'Toutes les données restent sur votre appareil';

  @override
  String get noBackend => 'Pas de backend';

  @override
  String get noServerNoAccount => 'Pas de serveur, pas de compte nécessaire';

  @override
  String get fullyOffline => 'Totalement hors ligne';

  @override
  String get worksWithoutInternet => 'Fonctionne sans internet';

  @override
  String get lightningFast => 'Ultra rapide';

  @override
  String get instantAccessNoLoading => 'Accès instantané, pas de chargement';

  @override
  String get pleaseEnterYourNameToContinue =>
      'Veuillez entrer votre nom pour continuer';

  @override
  String get welcomeToFynzDescription =>
      'Votre tracker de dépenses personnel qui fonctionne 100% hors ligne';

  @override
  String get personalizeExperienceDescription => 'Commençons par votre nom';
}
