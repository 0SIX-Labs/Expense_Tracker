import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../../config/environment_manager.dart';

/// Log levels
enum LogLevel { debug, info, warning, error }

/// Application logger with environment-aware logging
class AppLogger {
  static LogLevel _minLevel = LogLevel.debug;

  /// Set the minimum log level
  static void setMinLevel(LogLevel level) => _minLevel = level;

  /// Log a debug message
  static void debug(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.debug,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log an info message
  static void info(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.info,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a warning message
  static void warning(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.warning,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log an error message
  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    // Skip if below minimum level
    if (level.index < _minLevel.index) return;

    // Skip if logging is disabled in production
    if (!EnvironmentManager.config.enableLogging &&
        EnvironmentManager.isProduction)
      return;

    final prefix = tag != null ? '[$tag] ' : '';
    final levelStr = level.name.toUpperCase();
    final timestamp = DateTime.now().toIso8601String();
    final logMessage = '[$levelStr] $timestamp: $prefix$message';

    // Use developer.log in debug mode for better IDE integration
    if (kDebugMode) {
      developer.log(
        logMessage,
        name: tag ?? 'AppLogger',
        level: level.index * 100,
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      // In release mode, just print (can be redirected to crash reporting)
      // ignore: avoid_print
      print(logMessage);
      if (error != null) {
        // ignore: avoid_print
        print('Error: $error');
      }
      if (stackTrace != null) {
        // ignore: avoid_print
        print('StackTrace: $stackTrace');
      }
    }
  }
}
