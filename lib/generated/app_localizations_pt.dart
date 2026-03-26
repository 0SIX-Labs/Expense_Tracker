// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Fynz - Orçamento & Despesas';

  @override
  String get welcomeToFynz => 'Bem-vindo ao Fynz';

  @override
  String hello(String userName) {
    return 'Olá, $userName!';
  }

  @override
  String get settings => 'Configurações';

  @override
  String get home => 'Início';

  @override
  String get analytics => 'Análises';

  @override
  String get budget => 'Orçamento';

  @override
  String get addExpense => 'Adicionar Despesa';

  @override
  String get monthlyOverview => 'Visão Mensal';

  @override
  String get income => 'Receita';

  @override
  String get spent => 'Gasto';

  @override
  String get remaining => 'Restante';

  @override
  String get thisMonth => 'Este Mês';

  @override
  String get thisWeek => 'Esta Semana';

  @override
  String get spendingByCategory => 'Gastos por Categoria';

  @override
  String get recentTransactions => 'Transações Recentes';

  @override
  String get seeAll => 'Ver Tudo';

  @override
  String get onTrack => 'No Controle';

  @override
  String get overBudget => 'Acima do Orçamento';

  @override
  String get categories => 'Categorias';

  @override
  String get currency => 'Moeda';

  @override
  String get monthStartDay => 'Dia de Início do Mês';

  @override
  String get darkMode => 'Modo Escuro';

  @override
  String get notifications => 'Notificações';

  @override
  String get exportData => 'Exportar Dados';

  @override
  String get exportCSV => 'Exportar CSV';

  @override
  String get exportPDF => 'Exportar PDF';

  @override
  String get about => 'Sobre';

  @override
  String get version => 'Versão';

  @override
  String get developer => 'Desenvolvedor';

  @override
  String get license => 'Licença';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get termsOfService => 'Termos de Serviço';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get save => 'Salvar';

  @override
  String get edit => 'Editar';

  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get yourName => 'Seu Nome';

  @override
  String get personalizeExperience => 'Personalize sua Experiência';

  @override
  String get selectCurrency => 'Selecionar Moeda';

  @override
  String get currencyAutoDetected => 'Moeda detectada automaticamente';

  @override
  String get whenMonthStart => 'Quando seu mês começa?';

  @override
  String get monthStartDescription =>
      'Escolha o dia em que seu ciclo de faturamento começa para rastrear despesas com precisão';

  @override
  String get setMonthlyIncome => 'Defina sua renda mensal';

  @override
  String get monthlyIncomeDescription =>
      'Insira suas fontes de renda para ajudar a planejar seu orçamento de forma eficaz';

  @override
  String get allSet => 'Tudo Pronto!';

  @override
  String get allSetDescription =>
      'Seu perfil está pronto. Vamos começar a rastrear suas despesas';

  @override
  String get getStarted => 'Começar';

  @override
  String get next => 'Próximo';

  @override
  String get skip => 'Pular';

  @override
  String get salary => 'Salário';

  @override
  String get freelance => 'Freelance';

  @override
  String get investment => 'Investimento';

  @override
  String get other => 'Outro';

  @override
  String get otherIncome => 'Outras Receitas';

  @override
  String get foodAndDining => 'Alimentação & Restaurantes';

  @override
  String get transport => 'Transporte';

  @override
  String get shopping => 'Compras';

  @override
  String get entertainment => 'Entretenimento';

  @override
  String get billsAndUtilities => 'Contas & Serviços';

  @override
  String get healthcare => 'Saúde';

  @override
  String get education => 'Educação';

  @override
  String get travel => 'Viagens';

  @override
  String get groceries => 'Supermercado';

  @override
  String get deleteExpense => 'Excluir Despesa';

  @override
  String get confirmDelete => 'Tem certeza de que deseja excluir esta despesa?';

  @override
  String get expenseDeleted => 'Despesa excluída com sucesso';

  @override
  String get profileUpdated => 'Perfil atualizado com sucesso';

  @override
  String get manageCategories => 'Gerenciar Categorias';

  @override
  String get categoriesDescription =>
      'Crie e gerencie categorias personalizadas de despesas e receitas';

  @override
  String get getBudgetAlerts => 'Receber alertas e lembretes de orçamento';

  @override
  String get enableDarkTheme => 'Ativar tema escuro';

  @override
  String get customizeExperience => 'Personalize sua experiência';

  @override
  String get profile => 'Perfil';

  @override
  String monthStartsOnDay(int day) {
    return 'O mês começa no dia $day';
  }

  @override
  String yourBillingCycle(int day) {
    return 'Seu ciclo de faturamento começará no dia $day de cada mês';
  }

  @override
  String get monthlyIncomeSources => 'Fontes de Receita Mensal';

  @override
  String get dayOne => 'Dia 1';

  @override
  String get dayTwentyEight => 'Dia 28';

  @override
  String get selected => 'Selecionado';

  @override
  String get thisCurrencyWillBeUsed =>
      'Esta moeda será usada em todo o aplicativo para todas as transações';

  @override
  String get pleaseEnterYourName => 'Por favor, insira seu nome';

  @override
  String get failedToSaveProfile => 'Falha ao salvar perfil';

  @override
  String get anErrorOccurred => 'Ocorreu um erro. Por favor, tente novamente';

  @override
  String get failedToDeleteExpense => 'Falha ao excluir despesa';

  @override
  String get language => 'Idioma';

  @override
  String get chooseLanguage => 'Escolha seu idioma preferido';

  @override
  String get selectYourCurrency => 'Selecione sua moeda';

  @override
  String get billingCycleStart => 'Início do Ciclo de Faturamento';

  @override
  String get billingCycleDescription =>
      'Seu ciclo de rastreamento de despesas é reiniciado neste dia a cada mês';

  @override
  String get day => 'Dia';

  @override
  String get nativeMobileApp => 'Aplicativo Móvel Nativo';

  @override
  String get fullyPrivate => '100% Privado';

  @override
  String get allDataStaysOnDevice => 'Todos os dados ficam no seu dispositivo';

  @override
  String get noBackend => 'Sem Backend';

  @override
  String get noServerNoAccount => 'Sem servidor, sem necessidade de conta';

  @override
  String get fullyOffline => 'Totalmente Offline';

  @override
  String get worksWithoutInternet => 'Funciona sem internet';

  @override
  String get lightningFast => 'Ultra Rápido';

  @override
  String get instantAccessNoLoading => 'Acesso instantâneo, sem carregamento';

  @override
  String get pleaseEnterYourNameToContinue =>
      'Por favor, insira seu nome para continuar';

  @override
  String get welcomeToFynzDescription =>
      'Seu rastreador de despesas pessoal que funciona 100% offline';

  @override
  String get personalizeExperienceDescription => 'Vamos começar com seu nome';
}
