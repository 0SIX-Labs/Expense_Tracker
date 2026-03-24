// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Fynz - Presupuesto y Gastos';

  @override
  String get welcomeToFynz => 'Bienvenido a Fynz';

  @override
  String hello(String userName) {
    return '¡Hola, $userName!';
  }

  @override
  String get settings => 'Configuración';

  @override
  String get home => 'Inicio';

  @override
  String get analytics => 'Análisis';

  @override
  String get budget => 'Presupuesto';

  @override
  String get addExpense => 'Agregar Gasto';

  @override
  String get monthlyOverview => 'Resumen Mensual';

  @override
  String get income => 'Ingresos';

  @override
  String get spent => 'Gastado';

  @override
  String get remaining => 'Restante';

  @override
  String get thisMonth => 'Este Mes';

  @override
  String get thisWeek => 'Esta Semana';

  @override
  String get spendingByCategory => 'Gastos por Categoría';

  @override
  String get recentTransactions => 'Transacciones Recientes';

  @override
  String get seeAll => 'Ver Todo';

  @override
  String get onTrack => 'En Control';

  @override
  String get overBudget => 'Sobre Presupuesto';

  @override
  String get categories => 'Categorías';

  @override
  String get currency => 'Moneda';

  @override
  String get monthStartDay => 'Día de Inicio del Mes';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get exportData => 'Exportar Datos';

  @override
  String get exportCSV => 'Exportar CSV';

  @override
  String get exportPDF => 'Exportar PDF';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get developer => 'Desarrollador';

  @override
  String get license => 'Licencia';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get save => 'Guardar';

  @override
  String get edit => 'Editar';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get yourName => 'Tu Nombre';

  @override
  String get personalizeExperience => 'Personaliza Tu Experiencia';

  @override
  String get selectCurrency => 'Seleccionar Moneda';

  @override
  String get currencyAutoDetected => 'Moneda detectada automáticamente';

  @override
  String get whenMonthStart => '¿Cuándo comienza tu mes?';

  @override
  String get monthStartDescription => 'Elige el día en que comienza tu ciclo de facturación para rastrear gastos con precisión';

  @override
  String get setMonthlyIncome => 'Establece tus ingresos mensuales';

  @override
  String get monthlyIncomeDescription => 'Ingresa tus fuentes de ingresos para ayudar a planificar tu presupuesto efectivamente';

  @override
  String get allSet => '¡Todo Listo!';

  @override
  String get allSetDescription => 'Tu perfil está listo. Comencemos a rastrear tus gastos';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get next => 'Siguiente';

  @override
  String get skip => 'Omitir';

  @override
  String get salary => 'Salario';

  @override
  String get freelance => 'Freelance';

  @override
  String get investment => 'Inversión';

  @override
  String get other => 'Otro';

  @override
  String get otherIncome => 'Otros Ingresos';

  @override
  String get foodAndDining => 'Comida y Restaurantes';

  @override
  String get transport => 'Transporte';

  @override
  String get shopping => 'Compras';

  @override
  String get entertainment => 'Entretenimiento';

  @override
  String get billsAndUtilities => 'Facturas y Servicios';

  @override
  String get healthcare => 'Salud';

  @override
  String get education => 'Educación';

  @override
  String get travel => 'Viajes';

  @override
  String get groceries => 'Supermercado';

  @override
  String get deleteExpense => 'Eliminar Gasto';

  @override
  String get confirmDelete => '¿Estás seguro de que quieres eliminar este gasto?';

  @override
  String get expenseDeleted => 'Gasto eliminado exitosamente';

  @override
  String get profileUpdated => 'Perfil actualizado exitosamente';

  @override
  String get manageCategories => 'Gestionar Categorías';

  @override
  String get categoriesDescription => 'Crea y gestiona categorías personalizadas de gastos e ingresos';

  @override
  String get getBudgetAlerts => 'Recibir alertas y recordatorios de presupuesto';

  @override
  String get enableDarkTheme => 'Habilitar tema oscuro';

  @override
  String get customizeExperience => 'Personaliza tu experiencia';

  @override
  String get profile => 'Perfil';

  @override
  String monthStartsOnDay(int day) {
    return 'El mes comienza el día $day';
  }

  @override
  String yourBillingCycle(int day) {
    return 'Tu ciclo de facturación comenzará el día $day de cada mes';
  }

  @override
  String get monthlyIncomeSources => 'Fuentes de Ingresos Mensuales';

  @override
  String get dayOne => 'Día 1';

  @override
  String get dayTwentyEight => 'Día 28';

  @override
  String get selected => 'Seleccionado';

  @override
  String get thisCurrencyWillBeUsed => 'Esta moneda se usará en toda la app para todas las transacciones';

  @override
  String get pleaseEnterYourName => 'Por favor ingresa tu nombre';

  @override
  String get failedToSaveProfile => 'Error al guardar el perfil';

  @override
  String get anErrorOccurred => 'Ocurrió un error. Por favor intenta de nuevo';

  @override
  String get failedToDeleteExpense => 'Error al eliminar el gasto';
}
