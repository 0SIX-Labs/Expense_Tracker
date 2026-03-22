/// Result type for handling success/failure operations
sealed class Result<T> {
  const Result();

  /// Create a successful result
  const factory Result.success(T data) = Success<T>;

  /// Create a failure result
  const factory Result.failure(String message, {String? code, dynamic error}) =
      Failure<T>;

  /// Check if the result is successful
  bool get isSuccess => this is Success<T>;

  /// Check if the result is a failure
  bool get isFailure => this is Failure<T>;

  /// Get the data if successful, or null if failure
  T? get data => switch (this) {
    Success(:final data) => data,
    Failure() => null,
  };

  /// Get the error message if failure, or null if success
  String? get errorMessage => switch (this) {
    Success() => null,
    Failure(:final message) => message,
  };

  /// Execute a function if successful
  Result<T> onSuccess(void Function(T data) action) {
    if (this is Success<T>) {
      action((this as Success<T>).data);
    }
    return this;
  }

  /// Execute a function if failure
  Result<T> onFailure(
    void Function(String message, String? code, dynamic error) action,
  ) {
    if (this is Failure<T>) {
      final failure = this as Failure<T>;
      action(failure.message, failure.code, failure.error);
    }
    return this;
  }

  /// Transform the data if successful
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success(:final data) => Result.success(transform(data)),
      Failure(:final message, :final code, :final error) => Result.failure(
        message,
        code: code,
        error: error,
      ),
    };
  }
}

/// Successful result
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T> && data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Failure result
final class Failure<T> extends Result<T> {
  final String message;
  final String? code;
  final dynamic error;

  const Failure(this.message, {this.code, this.error});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> && message == other.message && code == other.code;

  @override
  int get hashCode => Object.hash(message, code);

  @override
  String toString() =>
      'Failure($message${code != null ? ', code: $code' : ''})';
}
