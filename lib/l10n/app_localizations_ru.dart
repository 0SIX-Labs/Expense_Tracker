// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Fynz - Приложение для отслеживания бюджета и расходов';

  @override
  String get welcomeToFynz => 'Добро пожаловать в Fynz';

  @override
  String hello(String userName) {
    return 'Привет, $userName!';
  }

  @override
  String get settings => 'Настройки';

  @override
  String get home => 'Главная';

  @override
  String get analytics => 'Аналитика';

  @override
  String get budget => 'Бюджет';

  @override
  String get addExpense => 'Добавить расход';

  @override
  String get monthlyOverview => 'Обзор месяца';

  @override
  String get income => 'Доход';

  @override
  String get spent => 'Потрачено';

  @override
  String get remaining => 'Осталось';

  @override
  String get thisMonth => 'В этом месяце';

  @override
  String get thisWeek => 'На этой неделе';

  @override
  String get spendingByCategory => 'Расходы по категориям';

  @override
  String get recentTransactions => 'Последние транзакции';

  @override
  String get seeAll => 'Посмотреть все';

  @override
  String get onTrack => 'В норме';

  @override
  String get overBudget => 'Превышение бюджета';

  @override
  String get categories => 'Категории';

  @override
  String get currency => 'Валюта';

  @override
  String get monthStartDay => 'День начала месяца';

  @override
  String get darkMode => 'Темный режим';

  @override
  String get notifications => 'Уведомления';

  @override
  String get exportData => 'Экспортировать данные';

  @override
  String get exportCSV => 'Экспортировать CSV';

  @override
  String get exportPDF => 'Экспортировать PDF';

  @override
  String get about => 'О приложении';

  @override
  String get version => 'Версия';

  @override
  String get developer => 'Разработчик';

  @override
  String get license => 'Лицензия';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get termsOfService => 'Условия обслуживания';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get save => 'Сохранить';

  @override
  String get edit => 'Редактировать';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get yourName => 'Ваше имя';

  @override
  String get personalizeExperience => 'Персонализируйте свой опыт';

  @override
  String get selectCurrency => 'Выберите валюту';

  @override
  String get currencyAutoDetected => 'Валюта автоматически определена';

  @override
  String get whenMonthStart => 'Когда начинается ваш месяц?';

  @override
  String get monthStartDescription => 'Выберите день, когда начинается ваш цикл выставления счетов, чтобы точно отслеживать расходы';

  @override
  String get setMonthlyIncome => 'Установите месячный доход';

  @override
  String get monthlyIncomeDescription => 'Введите источники дохода, чтобы эффективно планировать бюджет';

  @override
  String get allSet => 'Все готово!';

  @override
  String get allSetDescription => 'Ваш профиль готов. Начнем отслеживать ваши расходы';

  @override
  String get getStarted => 'Начать';

  @override
  String get next => 'Далее';

  @override
  String get skip => 'Пропустить';

  @override
  String get salary => 'Зарплата';

  @override
  String get freelance => 'Фриланс';

  @override
  String get investment => 'Инвестиции';

  @override
  String get other => 'Прочее';

  @override
  String get otherIncome => 'Прочий доход';

  @override
  String get foodAndDining => 'Еда и питание';

  @override
  String get transport => 'Транспорт';

  @override
  String get shopping => 'Покупки';

  @override
  String get entertainment => 'Развлечения';

  @override
  String get billsAndUtilities => 'Счета и коммунальные услуги';

  @override
  String get healthcare => 'Здравоохранение';

  @override
  String get education => 'Образование';

  @override
  String get travel => 'Путешествия';

  @override
  String get groceries => 'Продукты';

  @override
  String get deleteExpense => 'Удалить расход';

  @override
  String get confirmDelete => 'Вы уверены, что хотите удалить этот расход?';

  @override
  String get expenseDeleted => 'Расход успешно удален';

  @override
  String get profileUpdated => 'Профиль успешно обновлен';

  @override
  String get manageCategories => 'Управлять категориями';

  @override
  String get categoriesDescription => 'Создавайте и управляйте пользовательскими категориями расходов и доходов';

  @override
  String get getBudgetAlerts => 'Получайте оповещения о бюджете и напоминания';

  @override
  String get enableDarkTheme => 'Включить темную тему';

  @override
  String get customizeExperience => 'Настройте свой опыт';

  @override
  String get profile => 'Профиль';

  @override
  String monthStartsOnDay(int day) {
    return 'Месяц начинается $day-го числа';
  }

  @override
  String yourBillingCycle(int day) {
    return 'Ваш цикл выставления счетов начинается $day-го числа каждого месяца';
  }

  @override
  String get monthlyIncomeSources => 'Источники месячного дохода';

  @override
  String get dayOne => '1-й день';

  @override
  String get dayTwentyEight => '28-й день';

  @override
  String get selected => 'Выбрано';

  @override
  String get thisCurrencyWillBeUsed => 'Эта валюта будет использоваться во всем приложении для всех транзакций';

  @override
  String get pleaseEnterYourName => 'Пожалуйста, введите ваше имя';

  @override
  String get failedToSaveProfile => 'Не удалось сохранить профиль';

  @override
  String get anErrorOccurred => 'Произошла ошибка. Пожалуйста, попробуйте еще раз';

  @override
  String get failedToDeleteExpense => 'Не удалось удалить расход';
}
