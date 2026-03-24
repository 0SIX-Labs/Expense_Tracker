import 'app_environment.dart';
import 'env_development.dart';
import 'env_uat.dart';
import 'env_production.dart';

/// Manages the current application environment
class EnvironmentManager {
  static late EnvironmentConfig _config;

  /// Initialize the environment configuration
  /// Call this before runApp()
  static void initialize(AppEnvironment environment) {
    switch (environment) {
      case AppEnvironment.development:
        _config = developmentConfig;
        break;
      case AppEnvironment.uat:
        _config = uatConfig;
        break;
      case AppEnvironment.production:
        _config = productionConfig;
        break;
    }
  }

  /// Get the current environment configuration
  static EnvironmentConfig get config => _config;

  /// Get the current environment
  static AppEnvironment get environment => _config.environment;

  static bool get isDevelopment => _config.isDevelopment;

  static bool get isUat => _config.isUat;

  static bool get isProduction => _config.isProduction;
}
