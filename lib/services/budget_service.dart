import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/budget.dart';
import '../core/core.dart';

/// Service for managing budgets with full CRUD operations
class BudgetService {
  static final BudgetService _instance = BudgetService._internal();
  factory BudgetService() => _instance;
  BudgetService._internal();

  static const String _boxName = AppConstants.boxBudgets;
  final _uuid = const Uuid();

  /// Get the Hive box for budgets
  Future<Box<Budget>> get _box async => Hive.openBox<Budget>(_boxName);

  /// Create a new budget
  Future<Result<Budget>> create({
    required double amount,
    required BudgetPeriod period,
    required DateTime startDate,
    String? categoryId,
    String? name,
    String currency = AppConstants.defaultCurrency,
  }) async {
    try {
      final budget = Budget(
        id: _uuid.v4(),
        amount: amount,
        period: period,
        startDate: startDate,
        categoryId: categoryId,
        name: name,
        currency: currency,
        createdAt: DateTime.now(),
      );

      final box = await _box;
      await box.put(budget.id, budget);

      AppLogger.info('Created budget: ${budget.id}', tag: 'BudgetService');
      return Result.success(budget);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to create budget',
        tag: 'BudgetService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to create budget',
        code: 'BUDGET_CREATE_ERROR',
        error: e,
      );
    }
  }

  /// Get a budget by ID
  Future<Result<Budget?>> getById(String id) async {
    try {
      final box = await _box;
      final budget = box.get(id);
      return Result.success(budget);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get budget: $id',
        tag: 'BudgetService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get budget',
        code: 'BUDGET_GET_ERROR',
        error: e,
      );
    }
  }

  /// Get all budgets
  Future<Result<List<Budget>>> getAll() async {
    try {
      final box = await _box;
      final budgets = box.values.toList();
      budgets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Result.success(budgets);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get all budgets',
        tag: 'BudgetService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get budgets',
        code: 'BUDGET_GET_ALL_ERROR',
        error: e,
      );
    }
  }

  /// Get active budgets
  Future<Result<List<Budget>>> getActive() async {
    try {
      final box = await _box;
      final budgets = box.values.where((b) => b.isActive).toList();
      budgets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Result.success(budgets);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get active budgets',
        tag: 'BudgetService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get active budgets',
        code: 'BUDGET_GET_ACTIVE_ERROR',
        error: e,
      );
    }
  }

  /// Get budget by category
  Future<Result<Budget?>> getByCategory(String categoryId) async {
    try {
      final box = await _box;
      final budget = box.values
          .where((b) => b.categoryId == categoryId && b.isActive)
          .firstOrNull;
      return Result.success(budget);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get budget by category: $categoryId',
        tag: 'BudgetService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get budget',
        code: 'BUDGET_GET_BY_CATEGORY_ERROR',
        error: e,
      );
    }
  }

  /// Update an existing budget
  Future<Result<Budget>> update(Budget budget) async {
    try {
      final box = await _box;
      if (!box.containsKey(budget.id)) {
        return const Result.failure(
          'Budget not found',
          code: 'BUDGET_NOT_FOUND',
        );
      }

      final updatedBudget = budget.copyWith();
      await box.put(budget.id, updatedBudget);

      AppLogger.info('Updated budget: ${budget.id}', tag: 'BudgetService');
      return Result.success(updatedBudget);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update budget: ${budget.id}',
        tag: 'BudgetService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to update budget',
        code: 'BUDGET_UPDATE_ERROR',
        error: e,
      );
    }
  }

  /// Delete a budget
  Future<Result<void>> delete(String id) async {
    try {
      final box = await _box;
      await box.delete(id);

      AppLogger.info('Deleted budget: $id', tag: 'BudgetService');
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete budget: $id',
        tag: 'BudgetService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to delete budget',
        code: 'BUDGET_DELETE_ERROR',
        error: e,
      );
    }
  }

  /// Get total budget for active budgets
  Future<Result<double>> getTotalActive() async {
    try {
      final result = await getActive();
      if (result.isFailure) {
        return Result.failure(
          result.errorMessage ?? 'Failed to calculate total',
          code: 'BUDGET_TOTAL_ERROR',
        );
      }

      final total = result.data!.fold(0.0, (sum, b) => sum + b.amount);
      return Result.success(total);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to calculate active budget total',
        tag: 'BudgetService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to calculate total',
        code: 'BUDGET_TOTAL_ERROR',
        error: e,
      );
    }
  }

  /// Seed default budgets for new users
  Future<Result<void>> seedDefaults() async {
    try {
      final box = await _box;
      if (box.isNotEmpty) {
        AppLogger.info(
          'Budgets already exist, skipping seed',
          tag: 'BudgetService',
        );
        return const Result.success(null);
      }

      final now = DateTime.now();
      final defaultBudgets = [
        Budget(
          id: _uuid.v4(),
          amount: AppConstants.defaultBudgetAmount,
          period: BudgetPeriod.monthly,
          startDate: DateTime(now.year, now.month, 1),
          name: 'Monthly Food Budget',
          categoryId: 'food',
          createdAt: now,
        ),
        Budget(
          id: _uuid.v4(),
          amount: 200.00,
          period: BudgetPeriod.monthly,
          startDate: DateTime(now.year, now.month, 1),
          name: 'Transportation',
          categoryId: 'transport',
          createdAt: now,
        ),
      ];

      for (final budget in defaultBudgets) {
        await box.put(budget.id, budget);
      }

      AppLogger.info(
        'Seeded ${defaultBudgets.length} default budgets',
        tag: 'BudgetService',
      );
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to seed default budgets',
        tag: 'BudgetService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to seed default budgets',
        code: 'BUDGET_SEED_ERROR',
        error: e,
      );
    }
  }

  /// Clear all budgets
  Future<Result<void>> clearAll() async {
    try {
      final box = await _box;
      await box.clear();

      AppLogger.info('Cleared all budgets', tag: 'BudgetService');
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to clear budgets',
        tag: 'BudgetService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to clear budgets',
        code: 'BUDGET_CLEAR_ERROR',
        error: e,
      );
    }
  }
}
