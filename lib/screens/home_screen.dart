import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../models/income.dart';
import '../models/category.dart';
import '../services/services.dart';
import '../widgets/glass_card.dart';
import '../widgets/expense_card.dart';
import '../core/core.dart';
import 'add_expense_screen.dart';
import 'analytics_screen.dart';
import 'budget_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final ExpenseService _expenseService = ExpenseService();
  final UserProfileService _userProfileService = UserProfileService();
  final IncomeService _incomeService = IncomeService();

  List<Expense> _expenses = [];
  String _userName = 'User';
  double _totalIncome = 0;
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
      // Load user profile
      final profileResult = await _userProfileService.get();
      if (profileResult.isSuccess && profileResult.data != null) {
        _userName = profileResult.data!.name;
      }

      // Load expenses
      final expenseResult = await _expenseService.getAll();
      if (expenseResult.isSuccess) {
        _expenses = expenseResult.data!;
      }

      // Load income for current month
      final now = DateTime.now();
      final incomeResult = await _incomeService.getByMonthYear(
        now.month,
        now.year,
      );
      if (incomeResult.isSuccess) {
        _totalIncome = incomeResult.data!.fold(
          0.0,
          (sum, income) => sum + income.amount,
        );
      }

      // Calculate total spent this month
      final startOfMonth = DateTime(now.year, now.month, 1);
      _totalSpent = _expenses
          .where((e) => e.date.isAfter(startOfMonth))
          .fold(0.0, (sum, e) => sum + e.amount);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to load home data',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  double get _totalThisMonth {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return _expenses
        .where((e) => e.date.isAfter(startOfMonth))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  double get _totalThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return _expenses
        .where((e) => e.date.isAfter(startOfWeek))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [
              _buildHomeTab(),
              const AnalyticsScreen(),
              const BudgetScreen(),
              const SettingsScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildHomeTab() {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 120,
          floating: true,
          pinned: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $_userName! 👋',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Text(
                  'Expense Tracker',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Income Summary Card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildIncomeSummaryCard(),
          ),
        ),

        // Summary Cards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'This Month',
                    _totalThisMonth,
                    Icons.calendar_month,
                    [const Color(0xFF667eea), const Color(0xFF764ba2)],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'This Week',
                    _totalThisWeek,
                    Icons.date_range,
                    [const Color(0xFFf093fb), const Color(0xFFf5576c)],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Spending Chart
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildSpendingChart(),
          ),
        ),

        // Recent Transactions Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to all transactions
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Expenses List
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index >= _expenses.length) return null;
            return ExpenseCard(
              expense: _expenses[index],
              onTap: () => _editExpense(_expenses[index]),
              onDelete: () => _deleteExpense(_expenses[index]),
            );
          }, childCount: _expenses.length),
        ),

        // Bottom padding for FAB
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildIncomeSummaryCard() {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    final remaining = _totalIncome - _totalSpent;

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Overview',
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
                  color: remaining >= 0
                      ? Colors.green.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  remaining >= 0 ? 'On Track' : 'Over Budget',
                  style: TextStyle(
                    color: remaining >= 0 ? Colors.green[300] : Colors.red[300],
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Income',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currencyFormat.format(_totalIncome),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.2),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Spent',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currencyFormat.format(_totalSpent),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Remaining',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  currencyFormat.format(remaining),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: remaining >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    double amount,
    IconData icon,
    List<Color> gradientColors,
  ) {
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            currencyFormat.format(amount),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.3),
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.3),
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: -5,
          ),
          BoxShadow(
            color: const Color(0xFFf093fb).withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_rounded, 'Home', 0),
                _buildNavItem(Icons.bar_chart_rounded, 'Analytics', 1),
                _buildNavItem(
                  Icons.account_balance_wallet_rounded,
                  'Budget',
                  2,
                ),
                _buildNavItem(Icons.settings_rounded, 'Settings', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0.2),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF667eea).withOpacity(0.3)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.7),
                size: isSelected ? 22 : 20,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.7),
                fontSize: isSelected ? 12 : 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: isSelected ? 0.5 : 0.3,
              ),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingChart() {
    final Map<String, double> categoryTotals = {};
    for (final expense in _expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    final total = categoryTotals.values.fold(
      0.0,
      (sum, amount) => sum + amount,
    );
    if (total == 0) return const SizedBox.shrink();

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
          ...categoryTotals.entries.map((entry) {
            final category = Category.getCategoryById(entry.key);
            final percentage = (entry.value / total) * 100;

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  // Show category details
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      // Category Icon with hover effect
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: category.gradient),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: category.color.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          category.icon,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Category Name and Amount
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
                            Text(
                              '\$${entry.value.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Progress Bar
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${percentage.toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: percentage / 100,
                                backgroundColor: Colors.white.withOpacity(0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  category.color,
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _addExpense,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  void _addExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
    ).then((expense) {
      if (expense != null) {
        setState(() {
          _expenses.insert(0, expense);
        });
        _loadData(); // Refresh data
      }
    });
  }

  void _editExpense(Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(expense: expense),
      ),
    ).then((updatedExpense) {
      if (updatedExpense != null) {
        setState(() {
          final index = _expenses.indexWhere((e) => e.id == expense.id);
          if (index != -1) {
            _expenses[index] = updatedExpense;
          }
        });
        _loadData(); // Refresh data
      }
    });
  }

  void _deleteExpense(Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final result = await _expenseService.delete(expense.id);
              if (result.isSuccess) {
                setState(() {
                  _expenses.removeWhere((e) => e.id == expense.id);
                });
                _loadData(); // Refresh data
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Expense deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      result.errorMessage ?? 'Failed to delete expense',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
