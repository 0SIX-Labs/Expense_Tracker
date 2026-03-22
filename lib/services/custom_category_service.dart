import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/custom_category.dart';
import '../core/core.dart';

/// Service for managing custom categories with full CRUD operations
class CustomCategoryService {
  static final CustomCategoryService _instance =
      CustomCategoryService._internal();
  factory CustomCategoryService() => _instance;
  CustomCategoryService._internal();

  static const String _boxName = AppConstants.boxCustomCategories;
  final _uuid = const Uuid();

  /// Get the Hive box for custom categories
  Future<Box<CustomCategory>> get _box async =>
      Hive.openBox<CustomCategory>(_boxName);

  /// Create a new custom category
  Future<Result<CustomCategory>> create({
    required String name,
    required IconData icon,
    required Color color,
    bool isIncomeCategory = false,
  }) async {
    try {
      if (name.trim().isEmpty) {
        return const Result.failure(
          'Category name cannot be empty',
          code: 'INVALID_NAME',
        );
      }

      // Check for duplicate names
      final box = await _box;
      final existingCategory = box.values.any(
        (c) =>
            c.name.toLowerCase() == name.trim().toLowerCase() &&
            c.isIncomeCategory == isIncomeCategory,
      );

      if (existingCategory) {
        return const Result.failure(
          'A category with this name already exists',
          code: 'DUPLICATE_NAME',
        );
      }

      final category = CustomCategory(
        id: _uuid.v4(),
        name: name.trim(),
        iconCodePoint: icon.codePoint,
        colorValue: color.value,
        isIncomeCategory: isIncomeCategory,
        createdAt: DateTime.now(),
      );

      await box.put(category.id, category);

      AppLogger.info(
        'Created custom category: ${category.id}',
        tag: 'CustomCategoryService',
      );
      return Result.success(category);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to create custom category',
        tag: 'CustomCategoryService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to create custom category',
        code: 'CUSTOM_CATEGORY_CREATE_ERROR',
        error: e,
      );
    }
  }

  /// Get a custom category by ID
  Future<Result<CustomCategory?>> getById(String id) async {
    try {
      final box = await _box;
      final category = box.get(id);
      return Result.success(category);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get custom category: $id',
        tag: 'CustomCategoryService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get custom category',
        code: 'CUSTOM_CATEGORY_GET_ERROR',
        error: e,
      );
    }
  }

  /// Get all custom categories
  Future<Result<List<CustomCategory>>> getAll() async {
    try {
      final box = await _box;
      final categories = box.values.toList();
      categories.sort((a, b) => a.name.compareTo(b.name));
      return Result.success(categories);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get all custom categories',
        tag: 'CustomCategoryService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get custom categories',
        code: 'CUSTOM_CATEGORY_GET_ALL_ERROR',
        error: e,
      );
    }
  }

  /// Get expense categories (non-income categories)
  Future<Result<List<CustomCategory>>> getExpenseCategories() async {
    try {
      final box = await _box;
      final categories = box.values.where((c) => !c.isIncomeCategory).toList();
      categories.sort((a, b) => a.name.compareTo(b.name));
      return Result.success(categories);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get expense categories',
        tag: 'CustomCategoryService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get expense categories',
        code: 'CUSTOM_CATEGORY_GET_EXPENSE_ERROR',
        error: e,
      );
    }
  }

  /// Get income categories
  Future<Result<List<CustomCategory>>> getIncomeCategories() async {
    try {
      final box = await _box;
      final categories = box.values.where((c) => c.isIncomeCategory).toList();
      categories.sort((a, b) => a.name.compareTo(b.name));
      return Result.success(categories);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get income categories',
        tag: 'CustomCategoryService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get income categories',
        code: 'CUSTOM_CATEGORY_GET_INCOME_ERROR',
        error: e,
      );
    }
  }

  /// Update an existing custom category
  Future<Result<CustomCategory>> update(CustomCategory category) async {
    try {
      final box = await _box;
      if (!box.containsKey(category.id)) {
        return const Result.failure(
          'Custom category not found',
          code: 'CUSTOM_CATEGORY_NOT_FOUND',
        );
      }

      // Check for duplicate names (excluding current category)
      final existingCategory = box.values.any(
        (c) =>
            c.id != category.id &&
            c.name.toLowerCase() == category.name.toLowerCase() &&
            c.isIncomeCategory == category.isIncomeCategory,
      );

      if (existingCategory) {
        return const Result.failure(
          'A category with this name already exists',
          code: 'DUPLICATE_NAME',
        );
      }

      final updatedCategory = category.copyWith();
      await box.put(category.id, updatedCategory);

      AppLogger.info(
        'Updated custom category: ${category.id}',
        tag: 'CustomCategoryService',
      );
      return Result.success(updatedCategory);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update custom category: ${category.id}',
        tag: 'CustomCategoryService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to update custom category',
        code: 'CUSTOM_CATEGORY_UPDATE_ERROR',
        error: e,
      );
    }
  }

  /// Delete a custom category
  Future<Result<void>> delete(String id) async {
    try {
      final box = await _box;
      await box.delete(id);

      AppLogger.info(
        'Deleted custom category: $id',
        tag: 'CustomCategoryService',
      );
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete custom category: $id',
        tag: 'CustomCategoryService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to delete custom category',
        code: 'CUSTOM_CATEGORY_DELETE_ERROR',
        error: e,
      );
    }
  }

  /// Check if a category name exists
  Future<Result<bool>> nameExists(
    String name, {
    bool isIncomeCategory = false,
    String? excludeId,
  }) async {
    try {
      final box = await _box;
      final exists = box.values.any(
        (c) =>
            c.name.toLowerCase() == name.toLowerCase() &&
            c.isIncomeCategory == isIncomeCategory &&
            (excludeId == null || c.id != excludeId),
      );
      return Result.success(exists);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to check category name existence',
        tag: 'CustomCategoryService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to check category name',
        code: 'CUSTOM_CATEGORY_NAME_CHECK_ERROR',
        error: e,
      );
    }
  }

  /// Get count of custom categories
  Future<Result<int>> getCount({bool? isIncomeCategory}) async {
    try {
      final box = await _box;
      final count = isIncomeCategory == null
          ? box.length
          : box.values
                .where((c) => c.isIncomeCategory == isIncomeCategory)
                .length;
      return Result.success(count);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get custom category count',
        tag: 'CustomCategoryService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get category count',
        code: 'CUSTOM_CATEGORY_COUNT_ERROR',
        error: e,
      );
    }
  }

  /// Clear all custom categories
  Future<Result<void>> clearAll() async {
    try {
      final box = await _box;
      await box.clear();

      AppLogger.info(
        'Cleared all custom categories',
        tag: 'CustomCategoryService',
      );
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to clear custom categories',
        tag: 'CustomCategoryService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to clear custom categories',
        code: 'CUSTOM_CATEGORY_CLEAR_ERROR',
        error: e,
      );
    }
  }
}
