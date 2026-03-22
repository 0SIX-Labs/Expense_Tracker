import 'app_environment.dart';

/// Production environment configuration
final productionConfig = EnvironmentConfig(
  environment: AppEnvironment.production,
  appName: 'Expense Tracker',
  apiBaseUrl: 'https://api.expensetracker.com/api',
  enableLogging: false,
  enableAnalytics: true,
  enableCrashReporting: true,
  showDebugBanner: false,
  hiveBoxPrefix: '',
);
