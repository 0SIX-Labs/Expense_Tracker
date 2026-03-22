import 'app_environment.dart';

/// Development environment configuration
final developmentConfig = EnvironmentConfig(
  environment: AppEnvironment.development,
  appName: 'Expense Tracker (Dev)',
  apiBaseUrl: 'http://localhost:3000/api',
  enableLogging: true,
  enableAnalytics: false,
  enableCrashReporting: false,
  showDebugBanner: true,
  hiveBoxPrefix: 'dev_',
);
