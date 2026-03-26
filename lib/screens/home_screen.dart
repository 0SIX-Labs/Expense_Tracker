import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../models/income.dart';
import '../models/budget.dart';
import '../services/services.dart';
import '../widgets/glass_card.dart';
import '../core/core.dart';
import 'add_expense_screen.dart';
import 'analytics_screen.dart';
import 'budget_screen.dart';
import 'settings_screen.dart';
import 'transaction_history_screen.dart';

class ExpandableCategoryCard extends StatefulWidget {
  final Category category;
  final double amount;
  final double percentage;
  final VoidCallback onToggle;
  final List<Expense> expenses;

  const ExpandableCategoryCard({
    super.key,
    required this.category,
    required this.amount,
    required this.percentage,
    required this.onToggle,
    required this.expenses,
  });

  @override
  State<ExpandableCategoryCard> createState() => _ExpandableCategoryCardState();
}

class _ExpandableCategoryCardState extends State<ExpandableCategoryCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _heightAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _toggleExpansion,
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
                      gradient: LinearGradient(
                        colors: widget.category.gradient,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: widget.category.color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.category.icon,
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
                          widget.category.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FutureBuilder<NumberFormat>(
                          future: CurrencyUtils.getCurrencyFormatter(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('Loading...');
                            } else if (snapshot.hasError) {
                              return const Text('Error loading currency');
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              final currencyFormat = snapshot.data!;
                              return Text(
                                currencyFormat.format(widget.amount),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              );
                            } else {
                              return const Text('0.00');
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  // Progress Bar and Expand Icon
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${widget.percentage.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              _isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: widget.percentage / 100,
                            backgroundColor: Colors.white.withValues(
                              alpha: 0.1,
                            ),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              widget.category.color,
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
        ),

        // Budget Details (Expanded Content)
        SizeTransition(
          sizeFactor: _heightAnimation,
          axisAlignment: 0.0,
          child: _buildBudgetDetails(),
        ),
      ],
    );
  }

  Widget _buildBudgetDetails() {
    if (!_isExpanded) return const SizedBox.shrink();

    return FutureBuilder<List<Budget>>(
      future: _loadBudgetsForCategory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(left: 52, right: 16, bottom: 8),
            child: LinearProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const SizedBox.shrink();
        } else if (snapshot.hasData && snapshot.data != null) {
          final budgets = snapshot.data!;
          if (budgets.isEmpty) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(left: 52, right: 16, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: Color(0x4DFFFFFF), // 0.3 alpha = 77 decimal = 0x4D hex
                  thickness: 1,
                ),
                const SizedBox(height: 8),
                ...budgets.map((budget) => _buildBudgetRow(budget)),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildBudgetRow(Budget budget) {
    final spentInBudget = _calculateSpentInBudget(budget);
    final remaining = budget.amount - spentInBudget;
    final percentageUsed = budget.amount > 0
        ? (spentInBudget / budget.amount) * 100
        : 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Budget Name
          Expanded(
            child: Text(
              budget.name ?? 'Budget',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Budget Amount
          Expanded(
            child: FutureBuilder<NumberFormat>(
              future: CurrencyUtils.getCurrencyFormatter(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading...');
                } else if (snapshot.hasError) {
                  return const Text('Error loading currency');
                } else if (snapshot.hasData && snapshot.data != null) {
                  final currencyFormat = snapshot.data!;
                  return Text(
                    currencyFormat.format(spentInBudget),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  );
                } else {
                  return const Text('0.00');
                }
              },
            ),
          ),

          // Remaining and Progress
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${percentageUsed.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 11,
                    color: remaining >= 0 ? Colors.green[300] : Colors.red[300],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: percentageUsed / 100,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      remaining >= 0 ? Colors.green : Colors.red,
                    ),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Budget>> _loadBudgetsForCategory() async {
    try {
      final budgetService = BudgetService();
      final result = await budgetService.getAll();
      if (result.isSuccess) {
        return result.data!
            .where((budget) => budget.categoryId == widget.category.id)
            .toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  double _calculateSpentInBudget(Budget budget) {
    final cycleStart = budget.startDate;
    final cycleEnd = budget.endDate;

    return widget.category.id != null
        ? widget.expenses
              .where(
                (e) =>
                    e.category == widget.category.id &&
                    e.date.isAfter(
                      cycleStart.subtract(const Duration(days: 1)),
                    ) &&
                    e.date.isBefore(cycleEnd),
              )
              .fold(0.0, (sum, e) => sum + e.amount)
        : 0.0;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  ScrollController? _scrollController;

  final ExpenseService _expenseService = ExpenseService();
  final UserProfileService _userProfileService = UserProfileService();
  final IncomeService _incomeService = IncomeService();
  final BudgetService _budgetService = BudgetService();

  List<Expense> _expenses = [];
  String _userName = 'User';
  double _totalIncome = 0;
  double _totalSpent = 0;
  bool _isLoading = true;
<<<<<<< Updated upstream
=======
  int _monthStartDay = 1; // Add this to track billing cycle start day
  late AppLocalizations l10n;
  double _appBarOpacity = 1.0;
>>>>>>> Stashed changes

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
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
      backgroundColor: Colors.transparent,
      extendBody: true,
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
        // Simple App Bar
        SliverAppBar(
          expandedHeight: 120,
          floating: true,
          pinned: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
<<<<<<< Updated upstream
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
=======
          flexibleSpace: Center(
            child: Text(
              'Hi, ${_userName.isNotEmpty ? _userName[0].toUpperCase() + _userName.substring(1).toLowerCase() : 'User'}',
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
>>>>>>> Stashed changes
            ),
          ),
        ),

        // Monthly Overview Card
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

        // Expandable Category Cards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildExpandableCategoryCards(),
          ),
        ),

<<<<<<< Updated upstream
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

=======
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
=======
                      style: TextStyle(fontSize: 14, color: Colors.white),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
=======
                      style: TextStyle(fontSize: 14, color: Colors.white),
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
          Text(
            currencyFormat.format(amount),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
=======
          FutureBuilder<NumberFormat>(
            future: CurrencyUtils.getCurrencyFormatter(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                return const Text('Error loading currency');
              } else if (snapshot.hasData && snapshot.data != null) {
                final currencyFormat = snapshot.data!;
                final formattedAmount = currencyFormat.format(amount);

                return Text(
                  formattedAmount,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                );
              } else {
                return const Text('€ 0.00');
              }
            },
>>>>>>> Stashed changes
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF667eea).withOpacity(0.85),
            const Color(0xFF764ba2).withOpacity(0.85),
            const Color(0xFFf093fb).withOpacity(0.75),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withOpacity(0.5),
            blurRadius: 35,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: const Color(0xFFf093fb).withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF667eea).withOpacity(0.4)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF667eea).withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
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
                    : Colors.white.withOpacity(0.9),
                size: isSelected ? 22 : 20,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.9),
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

  Widget _buildQuickAction(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddIncomeDialog() {
    final amountController = TextEditingController();
    IncomeCategory selectedCategory = IncomeCategory.salary;

    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1a1a2e).withValues(alpha: 0.95),
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
                  Icons.add_circle,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Add Income',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2d2d3a),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButton<IncomeCategory>(
                    value: selectedCategory,
                    dropdownColor: const Color(0xFF1a1a2e),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    underline: Container(),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      setState(() {
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
                ),
                const SizedBox(height: 20),
                FutureBuilder<String>(
                  future: CurrencyUtils.getCurrencySymbol(),
                  builder: (context, snapshot) {
                    final prefixText = snapshot.data ?? '\$ ';
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2d2d3a),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
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
                          prefixText: prefixText,
                          prefixStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xFF667eea),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white.withValues(alpha: 0.8),
                backgroundColor: Colors.white.withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w600),
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
                  if (!mounted) return;
                  if (!mounted) return;
                  if (!mounted) return;
                  if (!mounted) return;
                  if (!mounted) return;
                  if (!mounted) return;
                  if (!mounted) return;
                  if (result.isSuccess) {
                    if (!mounted) return;
                    Navigator.pop(context);
                    _loadData(); // Refresh all data
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Income added successfully'),
                        backgroundColor: const Color(0xFF22c55e),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result.errorMessage ?? 'Failed to add income',
                        ),
                        backgroundColor: const Color(0xFFef4444),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                }
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
                style: TextStyle(fontWeight: FontWeight.w600),
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

  Widget _buildExpandableCategoryCards() {
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

            return ExpandableCategoryCard(
              category: category,
              amount: entry.value,
              percentage: percentage,
              onToggle: () {
                setState(() {
                  // Toggle expansion state
                });
              },
              expenses: _expenses,
            );
          }),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
