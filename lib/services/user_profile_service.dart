import 'package:hive/hive.dart';
import '../models/user_profile.dart';
import '../core/core.dart';

class UserProfileService {
  static final UserProfileService _instance = UserProfileService._internal();
  factory UserProfileService() => _instance;
  UserProfileService._internal();

  static const String _boxName = AppConstants.boxUserProfile;
  static const String _profileKey = 'current_user_profile';

  Future<Box<UserProfile>> get _box async =>
      Hive.openBox<UserProfile>(_boxName);

  Future<Result<UserProfile>> createOrUpdate({
    required String name,
    int monthStartDay = 1,
    String defaultCurrency = 'USD',
  }) async {
    try {
      final box = await _box;
      final existingProfile = box.get(_profileKey);

      final UserProfile profile;
      if (existingProfile != null) {
        profile = existingProfile.copyWith(
          name: name,
          monthStartDay: monthStartDay,
          defaultCurrency: defaultCurrency,
        );
      } else {
        profile = UserProfile(
          name: name,
          monthStartDay: monthStartDay,
          defaultCurrency: defaultCurrency,
        );
      }

      await box.put(_profileKey, profile);

      AppLogger.info(
        'User profile saved: ${profile.id}',
        tag: 'UserProfileService',
      );
      return Result.success(profile);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to save user profile',
        tag: 'UserProfileService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to save user profile',
        code: 'USER_PROFILE_SAVE_ERROR',
        error: e,
      );
    }
  }

  Future<Result<UserProfile?>> get() async {
    try {
      final box = await _box;
      final profile = box.get(_profileKey);
      return Result.success(profile);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get user profile',
        tag: 'UserProfileService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get user profile',
        code: 'USER_PROFILE_GET_ERROR',
        error: e,
      );
    }
  }

  Future<Result<bool>> exists() async {
    try {
      final box = await _box;
      final exists = box.containsKey(_profileKey);
      return Result.success(exists);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to check user profile existence',
        tag: 'UserProfileService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to check user profile',
        code: 'USER_PROFILE_EXISTS_ERROR',
        error: e,
      );
    }
  }

  Future<Result<UserProfile>> updateName(String name) async {
    try {
      final box = await _box;
      final existingProfile = box.get(_profileKey);

      if (existingProfile == null) {
        return const Result.failure(
          'User profile not found',
          code: 'USER_PROFILE_NOT_FOUND',
        );
      }

      final updatedProfile = existingProfile.copyWith(name: name);
      await box.put(_profileKey, updatedProfile);

      AppLogger.info('User name updated to: $name', tag: 'UserProfileService');
      return Result.success(updatedProfile);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update user name',
        tag: 'UserProfileService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to update user name',
        code: 'USER_PROFILE_UPDATE_NAME_ERROR',
        error: e,
      );
    }
  }

  Future<Result<UserProfile>> updateMonthStartDay(int monthStartDay) async {
    try {
      if (monthStartDay < 1 || monthStartDay > 28) {
        return const Result.failure(
          'Month start day must be between 1 and 28',
          code: 'INVALID_MONTH_START_DAY',
        );
      }

      final box = await _box;
      final existingProfile = box.get(_profileKey);

      if (existingProfile == null) {
        return const Result.failure(
          'User profile not found',
          code: 'USER_PROFILE_NOT_FOUND',
        );
      }

      final updatedProfile = existingProfile.copyWith(
        monthStartDay: monthStartDay,
      );
      await box.put(_profileKey, updatedProfile);

      AppLogger.info(
        'Month start day updated to: $monthStartDay',
        tag: 'UserProfileService',
      );
      return Result.success(updatedProfile);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update month start day',
        tag: 'UserProfileService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to update month start day',
        code: 'USER_PROFILE_UPDATE_MONTH_ERROR',
        error: e,
      );
    }
  }

  Future<Result<UserProfile>> updateDefaultCurrency(String currency) async {
    try {
      final box = await _box;
      final existingProfile = box.get(_profileKey);

      if (existingProfile == null) {
        return const Result.failure(
          'User profile not found',
          code: 'USER_PROFILE_NOT_FOUND',
        );
      }

      final updatedProfile = existingProfile.copyWith(
        defaultCurrency: currency,
      );
      await box.put(_profileKey, updatedProfile);

      AppLogger.info(
        'Default currency updated to: $currency',
        tag: 'UserProfileService',
      );
      return Result.success(updatedProfile);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update default currency',
        tag: 'UserProfileService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to update default currency',
        code: 'USER_PROFILE_UPDATE_CURRENCY_ERROR',
        error: e,
      );
    }
  }

  Future<Result<void>> delete() async {
    try {
      final box = await _box;
      await box.delete(_profileKey);

      AppLogger.info('User profile deleted', tag: 'UserProfileService');
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete user profile',
        tag: 'UserProfileService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to delete user profile',
        code: 'USER_PROFILE_DELETE_ERROR',
        error: e,
      );
    }
  }
}
