import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:expense_tracker/models/budget.dart';
import 'package:expense_tracker/services/budget_service.dart';
import 'package:expense_tracker/core/core.dart';

void main() {
  late BudgetService budgetService;

  setUpAll(() async {
    // Initialize Hive for testing
    await Hive.initFlutter();
    Hive.registerAdapter(BudgetAdapter());
    Hive.registerAdapter(BudgetPeriodAdapter());
  });

  setUp(() async {
    budgetService = BudgetService();
    // Clear any existing data
    await Hive.deleteBoxFromDisk(AppConstants.boxBudgets);
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(AppConstants.boxBudgets);
  });

  group('BudgetService', () {
    test('should create a budget', () async {
      final result = await budgetService.create(
        amount: 500.00,
        period: BudgetPeriod.monthly,
        startDate: DateTime.now(),
        categoryId: 'food',
        name: 'Monthly Food Budget',
      );

      expect(result.isSuccess, true);
      expect(result.data?.amount, 500.00);
      expect(result.data?.period, BudgetPeriod.monthly);
      expect(result.data?.categoryId, 'food');
    });

    test('should get budget by id', () async {
      // Create a budget first
      final createResult = await budgetService.create(
        amount: 200.00,
        period: BudgetPeriod.weekly,
        startDate: DateTime.now(),
      );

      expect(createResult.isSuccess, true);
      final id = createResult.data!.id;

      // Get the budget by id
      final getResult = await budgetService.getById(id);

      expect(getResult.isSuccess, true);
      expect(getResult.data?.id, id);
      expect(getResult.data?.amount, 200.00);
    });

    test('should get all budgets', () async {
      // Create multiple budgets
      await budgetService.create(
        amount: 500.00,
        period: BudgetPeriod.monthly,
        startDate: DateTime.now(),
      );
      await budgetService.create(
        amount: 200.00,
        period: BudgetPeriod.weekly,
        startDate: DateTime.now(),
      );

      final result = await budgetService.getAll();

      expect(result.isSuccess, true);
      expect(result.data?.length, 2);
    });

    test('should update a budget', () async {
      // Create a budget
      final createResult = await budgetService.create(
        amount: 300.00,
        period: BudgetPeriod.monthly,
        startDate: DateTime.now(),
        name: 'Original name',
      );

      expect(createResult.isSuccess, true);
      final budget = createResult.data!;

      // Update the budget
      final updatedBudget = budget.copyWith(
        amount: 350.00,
        name: 'Updated name',
      );

      final updateResult = await budgetService.update(updatedBudget);

      expect(updateResult.isSuccess, true);
      expect(updateResult.data?.amount, 350.00);
      expect(updateResult.data?.name, 'Updated name');
    });

    test('should delete a budget', () async {
      // Create a budget
      final createResult = await budgetService.create(
        amount: 400.00,
        period: BudgetPeriod.monthly,
        startDate: DateTime.now(),
      );

      expect(createResult.isSuccess, true);
      final id = createResult.data!.id;

      // Delete the budget
      final deleteResult = await budgetService.delete(id);

      expect(deleteResult.isSuccess, true);

      // Verify the budget is deleted
      final getResult = await budgetService.getById(id);
      expect(getResult.data, null);
    });

    test('should get active budgets', () async {
      final now = DateTime.now();

      // Create active budget
      await budgetService.create(
        amount: 500.00,
        period: BudgetPeriod.monthly,
        startDate: DateTime(now.year, now.month, 1),
      );

      // Create expired budget
      await budgetService.create(
        amount: 200.00,
        period: BudgetPeriod.monthly,
        startDate: DateTime(now.year, now.month - 2, 1),
      );

      final result = await budgetService.getActive();

      expect(result.isSuccess, true);
      expect(result.data?.length, 1);
    });

    test('should get budget by category', () async {
      final now = DateTime.now();

      // Create budgets
      await budgetService.create(
        amount: 500.00,
        period: BudgetPeriod.monthly,
        startDate: DateTime(now.year, now.month, 1),
        categoryId: 'food',
      );
      await budgetService.create(
        amount: 200.00,
        period: BudgetPeriod.monthly,
        startDate: DateTime(now.year, now.month, 1),
        categoryId: 'transport',
      );

      final result = await budgetService.getByCategory('food');

      expect(result.isSuccess, true);
      expect(result.data?.categoryId, 'food');
    });

    test('should get total active budget', () async {
      final now = DateTime.now();

      // Create active budgets
      await budgetService.create(
        amount: 500.00,
        period: BudgetPeriod.monthly,
        startDate: DateTime(now.year, now.month, 1),
      );
      await budgetService.create(
        amount: 200.00,
        period: BudgetPeriod.monthly,
        startDate: DateTime(now.year, now.month, 1),
      );

      final result = await budgetService.getTotalActive();

      expect(result.isSuccess, true);
      expect(result.data, 700.00);
    });

    test('should seed default budgets', () async {
      final result = await budgetService.seedDefaults();

      expect(result.isSuccess, true);

      final getAllResult = await budgetService.getAll();
      expect(getAllResult.data?.isNotEmpty, true);
    });

    test('should not seed defaults if budgets exist', () async {
      // Create a budget first
      await budgetService.create(
        amount: 500.00,
        period: BudgetPeriod.monthly,
        startDate: DateTime.now(),
      );

      // Try to seed defaults
      final result = await budgetService.seedDefaults();

      expect(result.isSuccess, true);

      // Should still have only 1 budget
      final getAllResult = await budgetService.getAll();
      expect(getAllResult.data?.length, 1);
    });

    test('should clear all budgets', () async {
      // Create some budgets
      await budgetService.create(
        amount: 500.00,
        period: BudgetPeriod.monthly,
        startDate: DateTime.now(),
      );
      await budgetService.create(
        amount: 200.00,
        period: BudgetPeriod.weekly,
        startDate: DateTime.now(),
      );

      // Clear all budgets
      final clearResult = await budgetService.clearAll();

      expect(clearResult.isSuccess, true);

      // Verify all budgets are cleared
      final getResult = await budgetService.getAll();
      expect(getResult.data?.length, 0);
    });
  });
}
