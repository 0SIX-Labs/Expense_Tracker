import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../widgets/glass_card.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _selectedPeriod = 'This Month';
  final List<String> _periods = ['This Week', 'This Month', 'This Year'];

  // Initialize with empty list - users will add their own expenses
  final List<Expense> _expenses = [];

  Map<String, double> get _categoryTotals {
    final totals = <String, double>{};
    for (final expense in _expenses) {
      totals[expense.category] =
          (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }

  double get _totalExpenses {
    return _expenses.fold(0.0, (sum, e) => sum + e.amount);
  }

  List<PieChartSectionData> get _pieChartSections {
    final totals = _categoryTotals;
    final total = _totalExpenses;
    final sections = <PieChartSectionData>[];

    totals.forEach((categoryId, amount) {
      final category = Category.getCategoryById(categoryId);
      final percentage = (amount / total) * 100;

      sections.add(
        PieChartSectionData(
          color: category.color,
          value: amount,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    });

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          // Header
          const Text(
            'Analytics',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track your spending patterns',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 24),

          // Period Selector
          _buildPeriodSelector(),
          const SizedBox(height: 24),

          // Total Spending Card
          _buildTotalSpendingCard(),
          const SizedBox(height: 24),

          // Pie Chart
          _buildPieChartCard(),
          const SizedBox(height: 24),

          // Category Breakdown
          _buildCategoryBreakdown(),
          const SizedBox(height: 24),

          // Top Expenses
          _buildTopExpenses(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return GlassCard(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: _periods.map((period) {
          final isSelected = _selectedPeriod == period;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTotalSpendingCard() {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Total Spending',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currencyFormat.format(_totalExpenses),
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem('Transactions', '${_expenses.length}'),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.2),
              ),
              _buildStatItem(
                'Avg/Day',
                currencyFormat.format(_totalExpenses / 30),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
        ),
      ],
    );
  }

  Widget _buildPieChartCard() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Spending by Category',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _pieChartSections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    final totals = _categoryTotals;
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Category Breakdown',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...totals.entries.map((entry) {
            final category = Category.getCategoryById(entry.key);
            final percentage = (entry.value / _totalExpenses) * 100;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: category.gradient),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(category.icon, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            category.color,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        currencyFormat.format(entry.value),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopExpenses() {
    final sortedExpenses = List<Expense>.from(_expenses)
      ..sort((a, b) => b.amount.compareTo(a.amount));
    final topExpenses = sortedExpenses.take(5).toList();
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Expenses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...topExpenses.asMap().entries.map((entry) {
            final index = entry.key;
            final expense = entry.value;
            final category = Category.getCategoryById(expense.category);

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: category.gradient),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(category.icon, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      expense.title ?? category.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    currencyFormat.format(expense.amount),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
