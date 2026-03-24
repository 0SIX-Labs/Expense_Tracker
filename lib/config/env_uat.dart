import 'app_environment.dart';

/// UAT (User Acceptance Testing) environment configuration
final uatConfig = EnvironmentConfig(
  environment: AppEnvironment.uat,
  appName: 'Fynz (UAT)',
  apiBaseUrl: 'https://uat-api.expensetracker.com/api',
  enableLogging: true,
  enableAnalytics: true,
  enableCrashReporting: true,
  showDebugBanner: false,
  hiveBoxPrefix: 'uat_',
);
