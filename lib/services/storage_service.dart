import 'package:hive_flutter/hive_flutter.dart';
import '../core/core.dart';
import '../config/environment_manager.dart';

/// Abstract storage service interface
abstract class IStorageService {
  Future<void> initialize();
  Future<Result<void>> save<T>(String boxName, String key, T value);
  Future<Result<T?>> get<T>(String boxName, String key, {T? defaultValue});
  Future<Result<void>> delete(String boxName, String key);
  Future<Result<void>> clear(String boxName);
  Future<Result<List<T>>> getAll<T>(String boxName);
  Future<Result<void>> close();
}

/// Hive-based storage service implementation
class StorageService implements IStorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  final Map<String, Box> _openBoxes = {};

  /// Get the box prefix based on environment
  String get _prefix => EnvironmentManager.config.hiveBoxPrefix;

  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
    AppLogger.info('StorageService initialized', tag: 'StorageService');
  }

  /// Get or open a Hive box
  Future<Box> _getBox(String boxName) async {
    final fullName = '$_prefix$boxName';

    if (_openBoxes.containsKey(fullName) && _openBoxes[fullName]!.isOpen) {
      return _openBoxes[fullName]!;
    }

    try {
      final box = await Hive.openBox(fullName);
      _openBoxes[fullName] = box;
      return box;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to open box: $fullName',
        tag: 'StorageService',
        error: e,
        stackTrace: stackTrace,
      );
      throw StorageException(
        message: 'Failed to open storage box: $fullName',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<Result<void>> save<T>(String boxName, String key, T value) async {
    try {
      final box = await _getBox(boxName);
      await box.put(key, value);
      AppLogger.debug('Saved $key to $boxName', tag: 'StorageService');
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to save $key to $boxName',
        tag: 'StorageService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to save data',
        code: 'STORAGE_SAVE_ERROR',
        error: e,
      );
    }
  }

  @override
  Future<Result<T?>> get<T>(
    String boxName,
    String key, {
    T? defaultValue,
  }) async {
    try {
      final box = await _getBox(boxName);
      final value = box.get(key, defaultValue: defaultValue) as T?;
      return Result.success(value);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get $key from $boxName',
        tag: 'StorageService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to retrieve data',
        code: 'STORAGE_GET_ERROR',
        error: e,
      );
    }
  }

  @override
  Future<Result<void>> delete(String boxName, String key) async {
    try {
      final box = await _getBox(boxName);
      await box.delete(key);
      AppLogger.debug('Deleted $key from $boxName', tag: 'StorageService');
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete $key from $boxName',
        tag: 'StorageService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to delete data',
        code: 'STORAGE_DELETE_ERROR',
        error: e,
      );
    }
  }

  @override
  Future<Result<void>> clear(String boxName) async {
    try {
      final box = await _getBox(boxName);
      await box.clear();
      AppLogger.info('Cleared box: $boxName', tag: 'StorageService');
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to clear box: $boxName',
        tag: 'StorageService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to clear storage',
        code: 'STORAGE_CLEAR_ERROR',
        error: e,
      );
    }
  }

  @override
  Future<Result<List<T>>> getAll<T>(String boxName) async {
    try {
      final box = await _getBox(boxName);
      final values = box.values.cast<T>().toList();
      return Result.success(values);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get all from $boxName',
        tag: 'StorageService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to retrieve all data',
        code: 'STORAGE_GET_ALL_ERROR',
        error: e,
      );
    }
  }

  @override
  Future<Result<void>> close() async {
    try {
      for (final box in _openBoxes.values) {
        if (box.isOpen) {
          await box.close();
        }
      }
      _openBoxes.clear();
      AppLogger.info('StorageService closed', tag: 'StorageService');
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to close storage service',
        tag: 'StorageService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to close storage',
        code: 'STORAGE_CLOSE_ERROR',
        error: e,
      );
    }
  }
}
