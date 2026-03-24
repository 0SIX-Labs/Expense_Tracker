// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Fynz - 予算＆支出管理アプリ';

  @override
  String get welcomeToFynz => 'Fynzへようこそ';

  @override
  String hello(String userName) {
    return 'こんにちは、$userNameさん！';
  }

  @override
  String get settings => '設定';

  @override
  String get home => 'ホーム';

  @override
  String get analytics => '分析';

  @override
  String get budget => '予算';

  @override
  String get addExpense => '支出を追加';

  @override
  String get monthlyOverview => '月間概要';

  @override
  String get income => '収入';

  @override
  String get spent => '使用済み';

  @override
  String get remaining => '残り';

  @override
  String get thisMonth => '今月';

  @override
  String get thisWeek => '今週';

  @override
  String get spendingByCategory => 'カテゴリ別支出';

  @override
  String get recentTransactions => '最近のトランザクション';

  @override
  String get seeAll => 'すべて表示';

  @override
  String get onTrack => '順調';

  @override
  String get overBudget => '予算超過';

  @override
  String get categories => 'カテゴリ';

  @override
  String get currency => '通貨';

  @override
  String get monthStartDay => '月の開始日';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get notifications => '通知';

  @override
  String get exportData => 'データをエクスポート';

  @override
  String get exportCSV => 'CSVをエクスポート';

  @override
  String get exportPDF => 'PDFをエクスポート';

  @override
  String get about => 'について';

  @override
  String get version => 'バージョン';

  @override
  String get developer => '開発者';

  @override
  String get license => 'ライセンス';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get termsOfService => '利用規約';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get save => '保存';

  @override
  String get edit => '編集';

  @override
  String get editProfile => 'プロフィール編集';

  @override
  String get yourName => 'お名前';

  @override
  String get personalizeExperience => 'エクスペリエンスをカスタマイズ';

  @override
  String get selectCurrency => '通貨を選択';

  @override
  String get currencyAutoDetected => '通貨が自動検出されました';

  @override
  String get whenMonthStart => '月をいつから始めますか？';

  @override
  String get monthStartDescription => '請求サイクルが始まる日を選択して、支出を正確に追跡してください';

  @override
  String get setMonthlyIncome => '月収を設定';

  @override
  String get monthlyIncomeDescription => '収入源を入力して、予算を効果的に計画するのに役立ててください';

  @override
  String get allSet => '完成しました！';

  @override
  String get allSetDescription => 'プロフィールの準備ができました。支出の追跡を始めましょう';

  @override
  String get getStarted => '始めましょう';

  @override
  String get next => '次へ';

  @override
  String get skip => 'スキップ';

  @override
  String get salary => '給与';

  @override
  String get freelance => 'フリーランス';

  @override
  String get investment => '投資';

  @override
  String get other => 'その他';

  @override
  String get otherIncome => 'その他の収入';

  @override
  String get foodAndDining => '食事＆ダイニング';

  @override
  String get transport => '交通';

  @override
  String get shopping => '買い物';

  @override
  String get entertainment => '娯楽';

  @override
  String get billsAndUtilities => '請求＆ユーティリティ';

  @override
  String get healthcare => 'ヘルスケア';

  @override
  String get education => '教育';

  @override
  String get travel => '旅行';

  @override
  String get groceries => '食料品';

  @override
  String get deleteExpense => '支出を削除';

  @override
  String get confirmDelete => 'この支出を削除してもよろしいですか？';

  @override
  String get expenseDeleted => '支出が正常に削除されました';

  @override
  String get profileUpdated => 'プロフィールが正常に更新されました';

  @override
  String get manageCategories => 'カテゴリを管理';

  @override
  String get categoriesDescription => 'カスタム支出収入カテゴリを作成および管理';

  @override
  String get getBudgetAlerts => '予算アラートとリマインダーを受け取る';

  @override
  String get enableDarkTheme => 'ダークテーマを有効にする';

  @override
  String get customizeExperience => 'エクスペリエンスをカスタマイズ';

  @override
  String get profile => 'プロフィール';

  @override
  String monthStartsOnDay(int day) {
    return '月は$day日に始まります';
  }

  @override
  String yourBillingCycle(int day) {
    return '請求サイクルは毎月$day日に開始されます';
  }

  @override
  String get monthlyIncomeSources => '月収源';

  @override
  String get dayOne => '1日';

  @override
  String get dayTwentyEight => '28日';

  @override
  String get selected => '選択済み';

  @override
  String get thisCurrencyWillBeUsed => 'この通貨はアプリ全体のすべてのトランザクションに使用されます';

  @override
  String get pleaseEnterYourName => 'お名前を入力してください';

  @override
  String get failedToSaveProfile => 'プロフィールの保存に失敗しました';

  @override
  String get anErrorOccurred => 'エラーが発生しました。もう一度お試しください';

  @override
  String get failedToDeleteExpense => '支出の削除に失敗しました';

  @override
  String get language => 'Language';

  @override
  String get chooseLanguage => 'Choose your preferred language';

  @override
  String get selectYourCurrency => 'Select your currency';

  @override
  String get billingCycleStart => 'Billing Cycle Start';

  @override
  String get billingCycleDescription =>
      'Your expense tracking cycle resets on this day each month';

  @override
  String get day => 'Day';

  @override
  String get nativeMobileApp => 'Native Mobile App';

  @override
  String get fullyPrivate => '100% Private';

  @override
  String get allDataStaysOnDevice => 'All data stays on your device';

  @override
  String get noBackend => 'No Backend';

  @override
  String get noServerNoAccount => 'No server, no account needed';

  @override
  String get fullyOffline => 'Fully Offline';

  @override
  String get worksWithoutInternet => 'Works without internet';

  @override
  String get lightningFast => 'Lightning Fast';

  @override
  String get instantAccessNoLoading => 'Instant access, no loading';

  @override
  String get pleaseEnterYourNameToContinue =>
      'Please enter your name to continue';

  @override
  String get welcomeToFynzDescription =>
      'Your personal expense tracker that works 100% offline';

  @override
  String get personalizeExperienceDescription =>
      'Let\'s start by getting your name';
}
