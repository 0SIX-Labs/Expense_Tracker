import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/budget.dart';
import '../models/income.dart';
import '../models/category.dart';
import '../services/services.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../core/core.dart';
import '../utils/currency_utils.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final BudgetService _budgetService = BudgetService();
  final IncomeService _incomeService = IncomeService();
  final ExpenseService _expenseService = ExpenseService();

  List<Budget> _budgets = [];
  List<Income> _incomes = [];
  Map<String, double> _spentAmounts = {};
  double _totalIncome = 0;
  double _totalBudget = 0;
  double _totalSpent = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final now = DateTime.now();

      final budgetResult = await _budgetService.getAll();
      if (budgetResult.isSuccess) {
        _budgets = budgetResult.data!;
        _totalBudget = _budgets.fold(0.0, (sum, b) => sum + b.amount);
      }

      final incomeResult = await _incomeService.getByMonthYear(
        now.month,
        now.year,
      );
      if (incomeResult.isSuccess) {
        _incomes = incomeResult.data!;
        _totalIncome = _incomes.fold(0.0, (sum, i) => sum + i.amount);
      }

      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);
      final expenseResult = await _expenseService.getByDateRange(
        startOfMonth,
        endOfMonth,
      );
      if (expenseResult.isSuccess) {
        final expenses = expenseResult.data!;
        _spentAmounts = {};
        _totalSpent = 0;
        for (final expense in expenses) {
          _spentAmounts[expense.category] =
              (_spentAmounts[expense.category] ?? 0) + expense.amount;
          _totalSpent += expense.amount;
        }
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to load budget data',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Budgets',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
<<<<<<< Updated upstream
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your spending limits',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
=======
            const SizedBox(height: 8),
            Text(
              'Manage your spending limits',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.8),
              ),
>>>>>>> Stashed changes
            ),
            const SizedBox(height: 24),
            _buildIncomeSummary(),
            const SizedBox(height: 16),
            _buildOverallSummary(),
            const SizedBox(height: 24),
            _buildAddBudgetButton(),
            const SizedBox(height: 24),
            _buildBudgetList(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeSummary() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Income',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: _showIncomeDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Manage',
                    style: TextStyle(
                      color: Colors.green[300],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FutureBuilder<NumberFormat>(
            future: CurrencyUtils.getCurrencyFormatter(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                return const Text('Error loading currency');
              } else if (snapshot.hasData && snapshot.data != null) {
                final currencyFormat = snapshot.data!;
                return Text(
                  currencyFormat.format(_totalIncome),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                );
              } else {
                return const Text('€ 0.00');
              }
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Available for budgeting',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallSummary() {
    final remaining = _totalBudget - _totalSpent;
    final percentage = _totalBudget > 0
        ? (_totalSpent / _totalBudget) * 100
        : 0;

<<<<<<< Updated upstream
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Overall Budget',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: percentage > 80
                      ? Colors.red.withOpacity(0.2)
                      : Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: percentage > 80
                        ? Colors.red[300]
                        : Colors.green[300],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Progress Circle
          SizedBox(
            height: 120,
            width: 120,
            child: Stack(
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: percentage / 100,
                    strokeWidth: 12,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      percentage > 80 ? Colors.red[400]! : Colors.green[400]!,
=======
    return FutureBuilder<NumberFormat>(
      future: CurrencyUtils.getCurrencyFormatter(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const GlassCard(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const GlassCard(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('Error loading currency')),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          final currencyFormat = snapshot.data!;
          return GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Overall Budget',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
>>>>>>> Stashed changes
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: percentage > 80
                            ? Colors.red.withValues(alpha: 0.2)
                            : Colors.green.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: percentage > 80
                              ? Colors.red[300]
                              : Colors.green[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
<<<<<<< Updated upstream
                      Text(
                        'of ${currencyFormat.format(_totalBudget)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.7),
=======
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 120,
                  width: 120,
                  child: Stack(
                    children: [
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: percentage / 100,
                          strokeWidth: 12,
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            percentage > 80
                                ? Colors.red[400]!
                                : Colors.green[400]!,
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currencyFormat.format(_totalSpent),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'of ${currencyFormat.format(_totalBudget)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
>>>>>>> Stashed changes
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem(
                      'Total Budget',
                      currencyFormat.format(_totalBudget),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    _buildStatItem('Spent', currencyFormat.format(_totalSpent)),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    _buildStatItem(
                      'Remaining',
                      currencyFormat.format(remaining),
                    ),
                  ],
                ),
              ],
            ),
<<<<<<< Updated upstream
          ),
          const SizedBox(height: 20),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                'Total Budget',
                currencyFormat.format(_totalBudget),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.2),
              ),
              _buildStatItem('Spent', currencyFormat.format(_totalSpent)),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.2),
              ),
              _buildStatItem('Remaining', currencyFormat.format(remaining)),
            ],
          ),
        ],
      ),
=======
          );
        } else {
          return const GlassCard(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('No currency data')),
          );
        }
      },
>>>>>>> Stashed changes
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.7)),
        ),
      ],
    );
  }

  Widget _buildAddBudgetButton() {
    return GradientButton(
      text: 'Add New Budget',
      onPressed: _showAddBudgetDialog,
      gradientColors: const [Color(0xFF667eea), Color(0xFF764ba2)],
      icon: const Icon(Icons.add, color: Colors.white),
    );
  }

  Widget _buildBudgetList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Budgets',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        if (_budgets.isEmpty)
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                'No budgets yet. Add your first budget!',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ),
          )
        else
          ..._budgets.map((budget) => _buildBudgetCard(budget)),
      ],
    );
  }

  Widget _buildBudgetCard(Budget budget) {
    final category = Category.getCategoryById(budget.categoryId ?? 'other');
    final spent = _spentAmounts[budget.categoryId] ?? 0.0;
    final percentage = budget.amount > 0 ? (spent / budget.amount) * 100 : 0;
    final remaining = budget.amount - spent;
    final dateFormat = DateFormat('MMM dd');

    return FutureBuilder<NumberFormat>(
      future: CurrencyUtils.getCurrencyFormatter(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const GlassCard(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const GlassCard(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            child: Center(child: Text('Error loading currency')),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          final currencyFormat = snapshot.data!;
          return GlassCard(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: category.gradient),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(category.icon, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            budget.name ?? category.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${budget.period.name.capitalize()} • ${dateFormat.format(budget.startDate)} - ${dateFormat.format(budget.endDate)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
<<<<<<< Updated upstream
                    const SizedBox(height: 4),
                    Text(
                      '${budget.period.name.capitalize()} • ${dateFormat.format(budget.startDate)} - ${dateFormat.format(budget.endDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
=======
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currencyFormat.format(budget.amount),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${percentage.toStringAsFixed(0)}% used',
                          style: TextStyle(
                            fontSize: 12,
                            color: percentage > 80
                                ? Colors.red[300]
                                : Colors.green[300],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Spent: ${currencyFormat.format(spent)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        Text(
                          'Remaining: ${currencyFormat.format(remaining)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: remaining < 0
                                ? Colors.red[300]
                                : Colors.green[300],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          percentage > 80 ? Colors.red[400]! : category.color,
                        ),
                        minHeight: 8,
>>>>>>> Stashed changes
                      ),
                    ),
                  ],
                ),
<<<<<<< Updated upstream
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormat.format(budget.amount),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(0)}% used',
                    style: TextStyle(
                      fontSize: 12,
                      color: percentage > 80
                          ? Colors.red[300]
                          : Colors.green[300],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress Bar
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Spent: ${currencyFormat.format(spent)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    'Remaining: ${currencyFormat.format(remaining)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: remaining < 0
                          ? Colors.red[300]
                          : Colors.green[300],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percentage > 80 ? Colors.red[400]! : category.color,
                  ),
                  minHeight: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _editBudget(budget),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Edit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () => _deleteBudget(budget),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Delete',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red[300],
                        fontWeight: FontWeight.w500,
=======
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _editBudget(budget),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Edit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _deleteBudget(budget),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Delete',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red[300],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
>>>>>>> Stashed changes
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const GlassCard(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(16),
            child: Center(child: Text('No currency data')),
          );
        }
      },
    );
  }

  // Dialog background color constant for consistency
  static const Color _dialogBg = Color(0xFF1E1E2E);
  static const double _dialogOpacity = 0.88;

  void _showIncomeDialog() {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: AlertDialog(
          backgroundColor: _dialogBg.withValues(alpha: _dialogOpacity),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 24,
                ),
              ),
<<<<<<< Updated upstream
              const SizedBox(height: 16),
              if (_incomes.isEmpty)
                Text(
                  'No income recorded this month',
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                )
              else
                ..._incomes.map(
                  (income) => ListTile(
                    title: Text(
                      income.displayName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      currencyFormat.format(income.amount),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
=======
              const SizedBox(width: 12),
              const Text(
                'Monthly Income',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
>>>>>>> Stashed changes
                ),
              ),
            ],
          ),
          content: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF667eea).withValues(alpha: 0.1),
                  const Color(0xFF764ba2).withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total: ${currencyFormat.format(_totalIncome)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_incomes.isEmpty)
                    Text(
                      'No income recorded this month',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    )
                  else
                    ..._incomes.map(
                      (income) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                income.displayName,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Text(
                              currencyFormat.format(income.amount),
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white70,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                ),
              ),
              child: const Text(
                'Close',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showAddIncomeDialog();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF667eea),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Add Income',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF667eea), width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  void _showAddIncomeDialog() {
    final amountController = TextEditingController();
    IncomeCategory selectedCategory = IncomeCategory.salary;
    showDialog(
      context: context,
<<<<<<< Updated upstream
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF2D2D3A),
          title: const Text(
            'Add Income',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<IncomeCategory>(
                value: selectedCategory,
                dropdownColor: const Color(0xFF2D2D3A),
                onChanged: (value) {
                  setDialogState(() {
                    selectedCategory = value!;
                  });
                },
                items: IncomeCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(
                      category.displayName,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  prefixText: '\$ ',
                  prefixStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  final now = DateTime.now();
                  final result = await _incomeService.create(
                    amount: amount,
                    category: selectedCategory,
                    month: now.month,
                    year: now.year,
                  );

                  if (result.isSuccess) {
                    Navigator.pop(context);
                    _loadData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Income added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result.errorMessage ?? 'Failed to add income',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddBudgetDialog() {
    final amountController = TextEditingController();
    final nameController = TextEditingController();
    String? selectedCategoryId;
    BudgetPeriod selectedPeriod = BudgetPeriod.monthly;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF2D2D3A),
          title: const Text(
            'Add Budget',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Budget Name (optional)',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: selectedCategoryId,
                  hint: Text(
                    'Select Category',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  dropdownColor: const Color(0xFF2D2D3A),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedCategoryId = value;
                    });
                  },
                  items: Category.defaultCategories.map((category) {
                    return DropdownMenuItem(
                      value: category.id,
                      child: Text(
                        category.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
=======
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            backgroundColor: _dialogBg.withValues(alpha: _dialogOpacity),
            title: const Text(
              'Add Income',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<IncomeCategory>(
                  value: selectedCategory,
                  dropdownColor: const Color(0xFF2D2D3D),
                  onChanged: (value) =>
                      setDialogState(() => selectedCategory = value!),
                  items: IncomeCategory.values
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.displayName,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
>>>>>>> Stashed changes
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    prefixText: '\$ ',
                    prefixStyle: const TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
<<<<<<< Updated upstream
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text);
                if (amount != null &&
                    amount > 0 &&
                    selectedCategoryId != null) {
                  final now = DateTime.now();
                  final result = await _budgetService.create(
                    amount: amount,
                    period: selectedPeriod,
                    startDate: DateTime(now.year, now.month, 1),
                    categoryId: selectedCategoryId,
                    name: nameController.text.isNotEmpty
                        ? nameController.text
                        : null,
                  );

                  if (result.isSuccess) {
                    Navigator.pop(context);
                    _loadData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Budget created successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result.errorMessage ?? 'Failed to create budget',
=======
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white70,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final amount = double.tryParse(amountController.text);
                  if (amount != null && amount > 0) {
                    final now = DateTime.now();
                    final result = await _incomeService.create(
                      amount: amount,
                      category: selectedCategory,
                      month: now.month,
                      year: now.year,
                    );
                    if (!mounted) return;
                    if (result.isSuccess) {
                      Navigator.pop(context);
                      _loadData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Income added successfully'),
                          backgroundColor: Colors.green,
>>>>>>> Stashed changes
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            result.errorMessage ?? 'Failed to add income',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF8B5CF6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddBudgetDialog() {
    final amountController = TextEditingController();
    final nameController = TextEditingController();
    String? selectedCategoryId;
    BudgetPeriod selectedPeriod = BudgetPeriod.monthly;
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            backgroundColor: _dialogBg.withValues(alpha: _dialogOpacity),
            title: const Text(
              'Add Budget',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Budget Name (optional)',
                      labelStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: selectedCategoryId,
                    hint: Text(
                      'Select Category',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    dropdownColor: const Color(0xFF2D2D3D),
                    onChanged: (value) =>
                        setDialogState(() => selectedCategoryId = value),
                    items: Category.defaultCategories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category.id,
                            child: Text(
                              category.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      labelStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      prefixText: '\$ ',
                      prefixStyle: const TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<BudgetPeriod>(
                    value: selectedPeriod,
                    dropdownColor: const Color(0xFF2D2D3D),
                    onChanged: (value) =>
                        setDialogState(() => selectedPeriod = value!),
                    items: BudgetPeriod.values
                        .map(
                          (period) => DropdownMenuItem(
                            value: period,
                            child: Text(
                              period.name.capitalize(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white70,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final amount = double.tryParse(amountController.text);
                  if (amount != null &&
                      amount > 0 &&
                      selectedCategoryId != null) {
                    final now = DateTime.now();
                    final result = await _budgetService.create(
                      amount: amount,
                      period: selectedPeriod,
                      startDate: DateTime(now.year, now.month, 1),
                      categoryId: selectedCategoryId,
                      name: nameController.text.isNotEmpty
                          ? nameController.text
                          : null,
                    );
                    if (!mounted) return;
                    if (result.isSuccess) {
                      Navigator.pop(context);
                      _loadData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Budget created successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            result.errorMessage ?? 'Failed to create budget',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF8B5CF6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Create',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editBudget(Budget budget) {
    final amountController = TextEditingController(
      text: budget.amount.toString(),
    );
    final nameController = TextEditingController(text: budget.name ?? '');
    String? selectedCategoryId = budget.categoryId;
    BudgetPeriod selectedPeriod = budget.period;
    showDialog(
      context: context,
<<<<<<< Updated upstream
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF2D2D3A),
          title: const Text(
            'Edit Budget',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Budget Name (optional)',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  value: selectedCategoryId,
                  hint: Text(
                    'Select Category',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                  dropdownColor: const Color(0xFF2D2D3A),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedCategoryId = value;
                    });
                  },
                  items: Category.defaultCategories.map((category) {
                    return DropdownMenuItem(
                      value: category.id,
                      child: Text(
                        category.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    prefixText: '\$ ',
                    prefixStyle: const TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButton<BudgetPeriod>(
                  value: selectedPeriod,
                  dropdownColor: const Color(0xFF2D2D3A),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedPeriod = value!;
                    });
                  },
                  items: BudgetPeriod.values.map((period) {
                    return DropdownMenuItem(
                      value: period,
                      child: Text(
                        period.name.capitalize(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text);
                if (amount != null &&
                    amount > 0 &&
                    selectedCategoryId != null) {
                  final updatedBudget = budget.copyWith(
                    amount: amount,
                    period: selectedPeriod,
                    categoryId: selectedCategoryId,
                    name: nameController.text.isNotEmpty
                        ? nameController.text
                        : null,
                  );

                  final result = await _budgetService.update(updatedBudget);

                  if (result.isSuccess) {
                    Navigator.pop(context);
                    _loadData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Budget updated successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result.errorMessage ?? 'Failed to update budget',
=======
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            backgroundColor: _dialogBg.withValues(alpha: _dialogOpacity),
            title: const Text(
              'Edit Budget',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Budget Name (optional)',
                      labelStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.3),
>>>>>>> Stashed changes
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<String>(
                    value: selectedCategoryId,
                    hint: Text(
                      'Select Category',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    dropdownColor: const Color(0xFF2D2D3D),
                    onChanged: (value) =>
                        setDialogState(() => selectedCategoryId = value),
                    items: Category.defaultCategories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category.id,
                            child: Text(
                              category.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      labelStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                      prefixText: '\$ ',
                      prefixStyle: const TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<BudgetPeriod>(
                    value: selectedPeriod,
                    dropdownColor: const Color(0xFF2D2D3D),
                    onChanged: (value) =>
                        setDialogState(() => selectedPeriod = value!),
                    items: BudgetPeriod.values
                        .map(
                          (period) => DropdownMenuItem(
                            value: period,
                            child: Text(
                              period.name.capitalize(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white70,
                  backgroundColor: Colors.white.withValues(alpha: 0.08),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final amount = double.tryParse(amountController.text);
                  if (amount != null &&
                      amount > 0 &&
                      selectedCategoryId != null) {
                    final updatedBudget = budget.copyWith(
                      amount: amount,
                      period: selectedPeriod,
                      categoryId: selectedCategoryId,
                      name: nameController.text.isNotEmpty
                          ? nameController.text
                          : null,
                    );
                    final result = await _budgetService.update(updatedBudget);
                    if (!mounted) return;
                    if (result.isSuccess) {
                      Navigator.pop(context);
                      _loadData();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Budget updated successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            result.errorMessage ?? 'Failed to update budget',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF8B5CF6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteBudget(Budget budget) {
    showDialog(
      context: context,
<<<<<<< Updated upstream
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D3A),
        title: const Text(
          'Delete Budget',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${budget.name ?? Category.getCategoryById(budget.categoryId ?? 'other').name}"?',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final result = await _budgetService.delete(budget.id);

              if (result.isSuccess) {
                Navigator.pop(context);
                _loadData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Budget deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      result.errorMessage ?? 'Failed to delete budget',
=======
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: AlertDialog(
          backgroundColor: _dialogBg.withValues(alpha: _dialogOpacity),
          title: const Text(
            'Delete Budget',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete "${budget.name ?? Category.getCategoryById(budget.categoryId ?? 'other').name}"?',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white70,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            TextButton(
              onPressed: () async {
                final result = await _budgetService.delete(budget.id);
                if (!mounted) return;
                if (result.isSuccess) {
                  Navigator.pop(context);
                  _loadData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Budget deleted successfully'),
                      backgroundColor: Colors.green,
>>>>>>> Stashed changes
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result.errorMessage ?? 'Failed to delete budget',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFEF4444),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
