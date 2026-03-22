import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../core/core.dart';

/// Service for calculating analytics and insights
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  /// Calculate spending by category for a date range
  Map<String, double> calculateCategorySpending(
    List<Expense> expenses,
    DateTime start,
    DateTime end,
  ) {
    final filtered = expenses.where(
      (e) => e.date.isAfter(start) && e.date.isBefore(end),
    );

    final spending = <String, double>{};
    for (final expense in filtered) {
      spending[expense.category] =
          (spending[expense.category] ?? 0) + expense.amount;
    }

    return spending;
  }

  /// Calculate total spending for a date range
  double calculateTotalSpending(
    List<Expense> expenses,
    DateTime start,
    DateTime end,
  ) {
    return expenses
        .where((e) => e.date.isAfter(start) && e.date.isBefore(end))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  /// Calculate daily average spending
  double calculateDailyAverage(
    List<Expense> expenses,
    DateTime start,
    DateTime end,
  ) {
    final total = calculateTotalSpending(expenses, start, end);
    final days = end.difference(start).inDays;
    return days > 0 ? total / days : 0;
  }

  /// Get spending trend (comparing current period to previous)
  SpendingTrend getSpendingTrend(
    List<Expense> expenses,
    DateTime currentStart,
    DateTime currentEnd,
  ) {
    final currentTotal = calculateTotalSpending(
      expenses,
      currentStart,
      currentEnd,
    );

    // Calculate previous period
    final periodLength = currentEnd.difference(currentStart).inDays;
    final previousStart = currentStart.subtract(Duration(days: periodLength));
    final previousEnd = currentStart;
    final previousTotal = calculateTotalSpending(
      expenses,
      previousStart,
      previousEnd,
    );

    if (previousTotal == 0) {
      return SpendingTrend(
        currentAmount: currentTotal,
        previousAmount: 0,
        percentageChange: 0,
        isIncreasing: true,
      );
    }

    final percentageChange =
        ((currentTotal - previousTotal) / previousTotal) * 100;

    return SpendingTrend(
      currentAmount: currentTotal,
      previousAmount: previousTotal,
      percentageChange: percentageChange,
      isIncreasing: currentTotal > previousTotal,
    );
  }

  /// Get top spending categories
  List<CategorySpending> getTopCategories(
    List<Expense> expenses,
    DateTime start,
    DateTime end, {
    int limit = 5,
  }) {
    final spending = calculateCategorySpending(expenses, start, end);
    final total = calculateTotalSpending(expenses, start, end);

    final categories = spending.entries.map((entry) {
      final category = Category.getCategoryById(entry.key);
      final percentage = total > 0 ? (entry.value / total) * 100 : 0.0;

      return CategorySpending(
        categoryId: entry.key,
        categoryName: category.name,
        amount: entry.value,
        percentage: percentage,
        color: category.color,
        icon: category.icon,
      );
    }).toList();

    categories.sort((a, b) => b.amount.compareTo(a.amount));
    return categories.take(limit).toList();
  }

  /// Get monthly spending breakdown
  List<MonthlySpending> getMonthlySpending(List<Expense> expenses, int year) {
    final monthlyData = <int, double>{};

    for (final expense in expenses) {
      if (expense.date.year == year) {
        monthlyData[expense.date.month] =
            (monthlyData[expense.date.month] ?? 0) + expense.amount;
      }
    }

    final formatter = DateFormat('MMM');
    return List.generate(12, (index) {
      final month = index + 1;
      final date = DateTime(year, month);
      return MonthlySpending(
        month: month,
        monthName: formatter.format(date),
        amount: monthlyData[month] ?? 0,
      );
    });
  }

  /// Calculate budget utilization
  BudgetUtilization calculateBudgetUtilization(Budget budget, double spent) {
    final remaining = budget.amount - spent;
    final percentage = budget.amount > 0 ? (spent / budget.amount) * 100 : 0.0;

    BudgetStatus status;
    if (percentage >= AppConstants.budgetDangerThreshold * 100) {
      status = BudgetStatus.danger;
    } else if (percentage >= AppConstants.budgetWarningThreshold * 100) {
      status = BudgetStatus.warning;
    } else {
      status = BudgetStatus.healthy;
    }

    return BudgetUtilization(
      budgetAmount: budget.amount,
      spentAmount: spent,
      remainingAmount: remaining,
      percentageUsed: percentage.toDouble(),
      status: status,
      dailyBudget: budget.getDailyBudget(),
      daysRemaining: budget.getRemainingDays(),
    );
  }

  /// Get top expenses for a period
  List<Expense> getTopExpenses(
    List<Expense> expenses,
    DateTime start,
    DateTime end, {
    int limit = 5,
  }) {
    final filtered = expenses
        .where((e) => e.date.isAfter(start) && e.date.isBefore(end))
        .toList();

    filtered.sort((a, b) => b.amount.compareTo(a.amount));
    return filtered.take(limit).toList();
  }

  /// Generate insights based on spending data
  List<SpendingInsight> generateInsights(
    List<Expense> expenses,
    DateTime start,
    DateTime end,
  ) {
    final insights = <SpendingInsight>[];

    final trend = getSpendingTrend(expenses, start, end);
    final topCategories = getTopCategories(expenses, start, end);

    // Spending trend insight
    if (trend.percentageChange.abs() > 10) {
      insights.add(
        SpendingInsight(
          type: trend.isIncreasing ? InsightType.warning : InsightType.positive,
          title: trend.isIncreasing
              ? 'Spending Increased'
              : 'Spending Decreased',
          message:
              'Your spending has ${trend.isIncreasing ? 'increased' : 'decreased'} by ${trend.percentageChange.abs().toStringAsFixed(1)}% compared to the previous period.',
          icon: trend.isIncreasing ? Icons.trending_up : Icons.trending_down,
        ),
      );
    }

    // Top category insight
    if (topCategories.isNotEmpty) {
      final top = topCategories.first;
      insights.add(
        SpendingInsight(
          type: InsightType.info,
          title: 'Top Spending Category',
          message:
              '${top.categoryName} accounts for ${top.percentage.toStringAsFixed(1)}% of your total spending.',
          icon: top.icon,
        ),
      );
    }

    return insights;
  }
}

/// Data classes for analytics results

class SpendingTrend {
  final double currentAmount;
  final double previousAmount;
  final double percentageChange;
  final bool isIncreasing;

  const SpendingTrend({
    required this.currentAmount,
    required this.previousAmount,
    required this.percentageChange,
    required this.isIncreasing,
  });
}

class CategorySpending {
  final String categoryId;
  final String categoryName;
  final double amount;
  final double percentage;
  final Color color;
  final IconData icon;

  const CategorySpending({
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.percentage,
    required this.color,
    required this.icon,
  });
}

class MonthlySpending {
  final int month;
  final String monthName;
  final double amount;

  const MonthlySpending({
    required this.month,
    required this.monthName,
    required this.amount,
  });
}

class BudgetUtilization {
  final double budgetAmount;
  final double spentAmount;
  final double remainingAmount;
  final double percentageUsed;
  final BudgetStatus status;
  final double dailyBudget;
  final double daysRemaining;

  const BudgetUtilization({
    required this.budgetAmount,
    required this.spentAmount,
    required this.remainingAmount,
    required this.percentageUsed,
    required this.status,
    required this.dailyBudget,
    required this.daysRemaining,
  });
}

enum BudgetStatus { healthy, warning, danger }

enum InsightType { info, warning, positive }

class SpendingInsight {
  final InsightType type;
  final String title;
  final String message;
  final IconData icon;

  const SpendingInsight({
    required this.type,
    required this.title,
    required this.message,
    required this.icon,
  });
}
