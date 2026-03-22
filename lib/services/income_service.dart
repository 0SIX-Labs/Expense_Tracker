import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/income.dart';
import '../core/core.dart';

/// Service for managing incomes with full CRUD operations
class IncomeService {
  static final IncomeService _instance = IncomeService._internal();
  factory IncomeService() => _instance;
  IncomeService._internal();

  static const String _boxName = AppConstants.boxIncomes;
  final _uuid = const Uuid();

  /// Get the Hive box for incomes
  Future<Box<Income>> get _box async => Hive.openBox<Income>(_boxName);

  /// Create a new income
  Future<Result<Income>> create({
    required double amount,
    required IncomeCategory category,
    String? customCategoryName,
    required int month,
    required int year,
    String? notes,
    DateTime? date,
  }) async {
    try {
      if (amount <= 0) {
        return const Result.failure(
          'Income amount must be greater than zero',
          code: 'INVALID_AMOUNT',
        );
      }

      if (category == IncomeCategory.other && customCategoryName == null) {
        return const Result.failure(
          'Custom category name is required for "Other" category',
          code: 'MISSING_CUSTOM_CATEGORY_NAME',
        );
      }

      final income = Income(
        id: _uuid.v4(),
        amount: amount,
        category: category,
        customCategoryName: customCategoryName,
        month: month,
        year: year,
        notes: notes,
        date: date,
        createdAt: DateTime.now(),
      );

      final box = await _box;
      await box.put(income.id, income);

      AppLogger.info('Created income: ${income.id}', tag: 'IncomeService');
      return Result.success(income);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to create income',
        tag: 'IncomeService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to create income',
        code: 'INCOME_CREATE_ERROR',
        error: e,
      );
    }
  }

  /// Get an income by ID
  Future<Result<Income?>> getById(String id) async {
    try {
      final box = await _box;
      final income = box.get(id);
      return Result.success(income);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get income: $id',
        tag: 'IncomeService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get income',
        code: 'INCOME_GET_ERROR',
        error: e,
      );
    }
  }

  /// Get all incomes
  Future<Result<List<Income>>> getAll() async {
    try {
      final box = await _box;
      final incomes = box.values.toList();
      incomes.sort((a, b) => b.date.compareTo(a.date));
      return Result.success(incomes);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get all incomes',
        tag: 'IncomeService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get incomes',
        code: 'INCOME_GET_ALL_ERROR',
        error: e,
      );
    }
  }

  /// Get incomes by month and year
  Future<Result<List<Income>>> getByMonthYear(int month, int year) async {
    try {
      final box = await _box;
      final incomes = box.values
          .where((i) => i.month == month && i.year == year)
          .toList();
      incomes.sort((a, b) => b.date.compareTo(a.date));
      return Result.success(incomes);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get incomes by month/year',
        tag: 'IncomeService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get incomes',
        code: 'INCOME_GET_BY_MONTH_ERROR',
        error: e,
      );
    }
  }

  /// Get total income for a month and year
  Future<Result<double>> getTotalByMonthYear(int month, int year) async {
    try {
      final result = await getByMonthYear(month, year);
      if (result.isFailure) {
        return Result.failure(
          result.errorMessage ?? 'Failed to calculate total',
          code: 'INCOME_TOTAL_ERROR',
        );
      }

      final total = result.data!.fold(0.0, (sum, i) => sum + i.amount);
      return Result.success(total);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to calculate total income',
        tag: 'IncomeService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to calculate total',
        code: 'INCOME_TOTAL_ERROR',
        error: e,
      );
    }
  }

  /// Get income category totals for a month and year
  Future<Result<Map<IncomeCategory, double>>> getCategoryTotals(
    int month,
    int year,
  ) async {
    try {
      final result = await getByMonthYear(month, year);
      if (result.isFailure) {
        return Result.failure(
          result.errorMessage ?? 'Failed to calculate category totals',
          code: 'INCOME_CATEGORY_TOTALS_ERROR',
        );
      }

      final Map<IncomeCategory, double> totals = {};
      for (final income in result.data!) {
        totals[income.category] =
            (totals[income.category] ?? 0) + income.amount;
      }

      return Result.success(totals);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to calculate income category totals',
        tag: 'IncomeService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to calculate category totals',
        code: 'INCOME_CATEGORY_TOTALS_ERROR',
        error: e,
      );
    }
  }

  /// Update an existing income
  Future<Result<Income>> update(Income income) async {
    try {
      final box = await _box;
      if (!box.containsKey(income.id)) {
        return const Result.failure(
          'Income not found',
          code: 'INCOME_NOT_FOUND',
        );
      }

      final updatedIncome = income.copyWith();
      await box.put(income.id, updatedIncome);

      AppLogger.info('Updated income: ${income.id}', tag: 'IncomeService');
      return Result.success(updatedIncome);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update income: ${income.id}',
        tag: 'IncomeService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to update income',
        code: 'INCOME_UPDATE_ERROR',
        error: e,
      );
    }
  }

  /// Delete an income
  Future<Result<void>> delete(String id) async {
    try {
      final box = await _box;
      await box.delete(id);

      AppLogger.info('Deleted income: $id', tag: 'IncomeService');
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete income: $id',
        tag: 'IncomeService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to delete income',
        code: 'INCOME_DELETE_ERROR',
        error: e,
      );
    }
  }

  /// Get recent incomes (limited)
  Future<Result<List<Income>>> getRecent({int limit = 10}) async {
    try {
      final box = await _box;
      final incomes = box.values.toList();
      incomes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Result.success(incomes.take(limit).toList());
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get recent incomes',
        tag: 'IncomeService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get recent incomes',
        code: 'INCOME_GET_RECENT_ERROR',
        error: e,
      );
    }
  }

  /// Clear all incomes
  Future<Result<void>> clearAll() async {
    try {
      final box = await _box;
      await box.clear();

      AppLogger.info('Cleared all incomes', tag: 'IncomeService');
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to clear incomes',
        tag: 'IncomeService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to clear incomes',
        code: 'INCOME_CLEAR_ERROR',
        error: e,
      );
    }
  }
}
