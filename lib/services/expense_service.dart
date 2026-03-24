import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';
import '../core/core.dart';

class ExpenseService {
  static final ExpenseService _instance = ExpenseService._internal();
  factory ExpenseService() => _instance;
  ExpenseService._internal();

  static const String _boxName = AppConstants.boxExpenses;
  final _uuid = const Uuid();

  Future<Box<Expense>> get _box async => Hive.openBox<Expense>(_boxName);

  Future<Result<Expense>> create({
    required double amount,
    required String category,
    required DateTime date,
    String? title,
    String? notes,
  }) async {
    try {
      final expense = Expense(
        id: _uuid.v4(),
        amount: amount,
        category: category,
        date: date,
        title: title,
        notes: notes,
        createdAt: DateTime.now(),
      );

      final box = await _box;
      await box.put(expense.id, expense);

      AppLogger.info('Created expense: ${expense.id}', tag: 'ExpenseService');
      return Result.success(expense);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to create expense',
        tag: 'ExpenseService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to create expense',
        code: 'EXPENSE_CREATE_ERROR',
        error: e,
      );
    }
  }

  Future<Result<Expense?>> getById(String id) async {
    try {
      final box = await _box;
      final expense = box.get(id);
      return Result.success(expense);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get expense: $id',
        tag: 'ExpenseService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get expense',
        code: 'EXPENSE_GET_ERROR',
        error: e,
      );
    }
  }

  Future<Result<List<Expense>>> getAll() async {
    try {
      final box = await _box;
      final expenses = box.values.toList();
      // Sort by date descending
      expenses.sort((a, b) => b.date.compareTo(a.date));
      return Result.success(expenses);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get all expenses',
        tag: 'ExpenseService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get expenses',
        code: 'EXPENSE_GET_ALL_ERROR',
        error: e,
      );
    }
  }

  Future<Result<List<Expense>>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final box = await _box;
      final expenses = box.values
          .where((e) => e.date.isAfter(start) && e.date.isBefore(end))
          .toList();
      expenses.sort((a, b) => b.date.compareTo(a.date));
      return Result.success(expenses);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get expenses by date range',
        tag: 'ExpenseService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get expenses',
        code: 'EXPENSE_GET_BY_DATE_ERROR',
        error: e,
      );
    }
  }

  Future<Result<List<Expense>>> getByCategory(String category) async {
    try {
      final box = await _box;
      final expenses = box.values.where((e) => e.category == category).toList();
      expenses.sort((a, b) => b.date.compareTo(a.date));
      return Result.success(expenses);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get expenses by category: $category',
        tag: 'ExpenseService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get expenses',
        code: 'EXPENSE_GET_BY_CATEGORY_ERROR',
        error: e,
      );
    }
  }

  Future<Result<List<Expense>>> getRecent({int limit = 10}) async {
    try {
      final box = await _box;
      final expenses = box.values.toList();
      expenses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Result.success(expenses.take(limit).toList());
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get recent expenses',
        tag: 'ExpenseService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to get recent expenses',
        code: 'EXPENSE_GET_RECENT_ERROR',
        error: e,
      );
    }
  }

  Future<Result<Expense>> update(Expense expense) async {
    try {
      final box = await _box;
      if (!box.containsKey(expense.id)) {
        return const Result.failure(
          'Expense not found',
          code: 'EXPENSE_NOT_FOUND',
        );
      }

      final updatedExpense = expense.copyWith();
      await box.put(expense.id, updatedExpense);

      AppLogger.info('Updated expense: ${expense.id}', tag: 'ExpenseService');
      return Result.success(updatedExpense);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update expense: ${expense.id}',
        tag: 'ExpenseService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to update expense',
        code: 'EXPENSE_UPDATE_ERROR',
        error: e,
      );
    }
  }

  Future<Result<void>> delete(String id) async {
    try {
      final box = await _box;
      await box.delete(id);

      AppLogger.info('Deleted expense: $id', tag: 'ExpenseService');
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete expense: $id',
        tag: 'ExpenseService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to delete expense',
        code: 'EXPENSE_DELETE_ERROR',
        error: e,
      );
    }
  }

  Future<Result<double>> getTotal(DateTime start, DateTime end) async {
    try {
      final result = await getByDateRange(start, end);
      if (result.isFailure) {
        return Result.failure(
          result.errorMessage ?? 'Failed to calculate total',
          code: 'EXPENSE_TOTAL_ERROR',
        );
      }

      final total = result.data!.fold(0.0, (sum, e) => sum + e.amount);
      return Result.success(total);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to calculate total',
        tag: 'ExpenseService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to calculate total',
        code: 'EXPENSE_TOTAL_ERROR',
        error: e,
      );
    }
  }

  Future<Result<Map<String, double>>> getCategoryTotals(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final result = await getByDateRange(start, end);
      if (result.isFailure) {
        return Result.failure(
          result.errorMessage ?? 'Failed to calculate category totals',
          code: 'EXPENSE_CATEGORY_TOTALS_ERROR',
        );
      }

      final Map<String, double> totals = {};
      for (final expense in result.data!) {
        totals[expense.category] =
            (totals[expense.category] ?? 0) + expense.amount;
      }

      return Result.success(totals);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to calculate category totals',
        tag: 'ExpenseService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to calculate category totals',
        code: 'EXPENSE_CATEGORY_TOTALS_ERROR',
        error: e,
      );
    }
  }

  Future<Result<void>> clearAll() async {
    try {
      final box = await _box;
      await box.clear();

      AppLogger.info('Cleared all expenses', tag: 'ExpenseService');
      return const Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to clear expenses',
        tag: 'ExpenseService',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(
        'Failed to clear expenses',
        code: 'EXPENSE_CLEAR_ERROR',
        error: e,
      );
    }
  }
}
