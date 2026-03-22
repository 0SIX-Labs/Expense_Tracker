/// Base application exception
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() =>
      'AppException: $message${code != null ? ' ($code)' : ''}';
}

/// Storage-related exceptions
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() =>
      'StorageException: $message${code != null ? ' ($code)' : ''}';
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    this.fieldErrors,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() =>
      'ValidationException: $message${code != null ? ' ($code)' : ''}';
}

/// Network exceptions
class NetworkException extends AppException {
  final int? statusCode;

  const NetworkException({
    required super.message,
    this.statusCode,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() =>
      'NetworkException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}
