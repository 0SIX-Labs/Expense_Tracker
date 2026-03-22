/// Application environment configuration
enum AppEnvironment { development, uat, production }

class EnvironmentConfig {
  final AppEnvironment environment;
  final String appName;
  final String apiBaseUrl;
  final bool enableLogging;
  final bool enableAnalytics;
  final bool enableCrashReporting;
  final bool showDebugBanner;
  final String hiveBoxPrefix;

  const EnvironmentConfig({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    required this.enableLogging,
    required this.enableAnalytics,
    required this.enableCrashReporting,
    required this.showDebugBanner,
    this.hiveBoxPrefix = '',
  });

  bool get isDevelopment => environment == AppEnvironment.development;
  bool get isUat => environment == AppEnvironment.uat;
  bool get isProduction => environment == AppEnvironment.production;
}
