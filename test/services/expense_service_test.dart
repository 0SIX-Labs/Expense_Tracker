import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/services/expense_service.dart';
import 'package:expense_tracker/core/core.dart';

void main() {
  late ExpenseService expenseService;

  setUpAll(() async {
    // Initialize Hive for testing
    await Hive.initFlutter();
    Hive.registerAdapter(ExpenseAdapter());
  });

  setUp(() async {
    expenseService = ExpenseService();
    // Clear any existing data
    await Hive.deleteBoxFromDisk(AppConstants.boxExpenses);
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(AppConstants.boxExpenses);
  });

  group('ExpenseService', () {
    test('should create an expense', () async {
      final result = await expenseService.create(
        amount: 25.50,
        category: 'food',
        date: DateTime.now(),
        title: 'Test expense',
      );

      expect(result.isSuccess, true);
      expect(result.data?.amount, 25.50);
      expect(result.data?.category, 'food');
      expect(result.data?.title, 'Test expense');
    });

    test('should get expense by id', () async {
      // Create an expense first
      final createResult = await expenseService.create(
        amount: 50.00,
        category: 'transport',
        date: DateTime.now(),
      );

      expect(createResult.isSuccess, true);
      final id = createResult.data!.id;

      // Get the expense by id
      final getResult = await expenseService.getById(id);

      expect(getResult.isSuccess, true);
      expect(getResult.data?.id, id);
      expect(getResult.data?.amount, 50.00);
    });

    test('should get all expenses', () async {
      // Create multiple expenses
      await expenseService.create(
        amount: 10.00,
        category: 'food',
        date: DateTime.now(),
      );
      await expenseService.create(
        amount: 20.00,
        category: 'shopping',
        date: DateTime.now(),
      );

      final result = await expenseService.getAll();

      expect(result.isSuccess, true);
      expect(result.data?.length, 2);
    });

    test('should update an expense', () async {
      // Create an expense
      final createResult = await expenseService.create(
        amount: 30.00,
        category: 'food',
        date: DateTime.now(),
        title: 'Original title',
      );

      expect(createResult.isSuccess, true);
      final expense = createResult.data!;

      // Update the expense
      final updatedExpense = expense.copyWith(
        amount: 35.00,
        title: 'Updated title',
      );

      final updateResult = await expenseService.update(updatedExpense);

      expect(updateResult.isSuccess, true);
      expect(updateResult.data?.amount, 35.00);
      expect(updateResult.data?.title, 'Updated title');
    });

    test('should delete an expense', () async {
      // Create an expense
      final createResult = await expenseService.create(
        amount: 40.00,
        category: 'food',
        date: DateTime.now(),
      );

      expect(createResult.isSuccess, true);
      final id = createResult.data!.id;

      // Delete the expense
      final deleteResult = await expenseService.delete(id);

      expect(deleteResult.isSuccess, true);

      // Verify the expense is deleted
      final getResult = await expenseService.getById(id);
      expect(getResult.data, null);
    });

    test('should get expenses by date range', () async {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final tomorrow = now.add(const Duration(days: 1));

      // Create expenses
      await expenseService.create(amount: 10.00, category: 'food', date: now);
      await expenseService.create(
        amount: 20.00,
        category: 'shopping',
        date: yesterday,
      );

      final result = await expenseService.getByDateRange(yesterday, tomorrow);

      expect(result.isSuccess, true);
      expect(result.data?.length, 2);
    });

    test('should get expenses by category', () async {
      // Create expenses in different categories
      await expenseService.create(
        amount: 10.00,
        category: 'food',
        date: DateTime.now(),
      );
      await expenseService.create(
        amount: 20.00,
        category: 'food',
        date: DateTime.now(),
      );
      await expenseService.create(
        amount: 30.00,
        category: 'shopping',
        date: DateTime.now(),
      );

      final result = await expenseService.getByCategory('food');

      expect(result.isSuccess, true);
      expect(result.data?.length, 2);
    });

    test('should get total expenses for date range', () async {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final tomorrow = now.add(const Duration(days: 1));

      // Create expenses
      await expenseService.create(amount: 10.00, category: 'food', date: now);
      await expenseService.create(
        amount: 20.00,
        category: 'shopping',
        date: now,
      );

      final result = await expenseService.getTotal(yesterday, tomorrow);

      expect(result.isSuccess, true);
      expect(result.data, 30.00);
    });

    test('should get category totals', () async {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final tomorrow = now.add(const Duration(days: 1));

      // Create expenses
      await expenseService.create(amount: 10.00, category: 'food', date: now);
      await expenseService.create(
        amount: 20.00,
        category: 'shopping',
        date: now,
      );
      await expenseService.create(amount: 30.00, category: 'food', date: now);

      final result = await expenseService.getCategoryTotals(
        yesterday,
        tomorrow,
      );

      expect(result.isSuccess, true);
      expect(result.data?['food'], 40.00);
      expect(result.data?['shopping'], 20.00);
    });

    test('should get recent expenses', () async {
      // Create multiple expenses
      for (int i = 0; i < 15; i++) {
        await expenseService.create(
          amount: i.toDouble(),
          category: 'food',
          date: DateTime.now(),
        );
      }

      final result = await expenseService.getRecent(limit: 10);

      expect(result.isSuccess, true);
      expect(result.data?.length, 10);
    });

    test('should clear all expenses', () async {
      // Create some expenses
      await expenseService.create(
        amount: 10.00,
        category: 'food',
        date: DateTime.now(),
      );
      await expenseService.create(
        amount: 20.00,
        category: 'shopping',
        date: DateTime.now(),
      );

      // Clear all expenses
      final clearResult = await expenseService.clearAll();

      expect(clearResult.isSuccess, true);

      // Verify all expenses are cleared
      final getResult = await expenseService.getAll();
      expect(getResult.data?.length, 0);
    });
  });
}
