import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/custom_category.dart';
import '../services/services.dart';
import '../widgets/glass_card.dart';
import '../core/core.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CustomCategoryService _categoryService = CustomCategoryService();

  List<CustomCategory> _expenseCategories = [];
  List<CustomCategory> _incomeCategories = [];
  bool _isLoading = true;

  final List<IconData> _availableIcons = [
    Icons.shopping_bag,
    Icons.restaurant,
    Icons.directions_car,
    Icons.movie,
    Icons.receipt_long,
    Icons.local_hospital,
    Icons.school,
    Icons.flight,
    Icons.home,
    Icons.sports_soccer,
    Icons.pets,
    Icons.work,
    Icons.fitness_center,
    Icons.music_note,
    Icons.palette,
    Icons.park,
    Icons.wifi,
    Icons.phone,
    Icons.electric_bolt,
    Icons.water_drop,
    Icons.coffee,
    Icons.shopping_cart,
    Icons.computer,
    Icons.games,
    Icons.book,
    Icons.fitness_center,
    Icons.spa,
    Icons.beach_access,
    Icons.celebration,
    Icons.card_giftcard,
  ];

  final List<Color> _availableColors = [
    const Color(0xFFFF6B6B),
    const Color(0xFF4ECDC4),
    const Color(0xFFFFB347),
    const Color(0xFF9B59B6),
    const Color(0xFF3498DB),
    const Color(0xFFE74C3C),
    const Color(0xFF2ECC71),
    const Color(0xFF1ABC9C),
    const Color(0xFF95A5A6),
    const Color(0xFF7F8C8D),
    const Color(0xFFE67E22),
    const Color(0xFF8E44AD),
    const Color(0xFF2980B9),
    const Color(0xFF27AE60),
    const Color(0xFFF39C12),
    const Color(0xFFD35400),
    const Color(0xFFC0392B),
    const Color(0xFF16A085),
    const Color(0xFF2C3E50),
    const Color(0xFF34495E),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCategories();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final expenseResult = await _categoryService.getExpenseCategories();
      final incomeResult = await _categoryService.getIncomeCategories();

      if (expenseResult.isSuccess) {
        _expenseCategories = expenseResult.data!;
      }

      if (incomeResult.isSuccess) {
        _incomeCategories = incomeResult.data!;
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to load categories',
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
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFFf093fb)],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          'Manage Categories',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

<<<<<<< Updated upstream
              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withOpacity(0.7),
                  tabs: const [
                    Tab(text: 'Expense'),
                    Tab(text: 'Income'),
                  ],
=======
                // Tab Bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
                    tabs: const [
                      Tab(text: 'Expense'),
                      Tab(text: 'Income'),
                    ],
                  ),
>>>>>>> Stashed changes
                ),

                const SizedBox(height: 16),

                // Tab Bar View
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCategoryList(false),
                      _buildCategoryList(true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildCategoryList(bool isIncome) {
    final categories = isIncome ? _incomeCategories : _expenseCategories;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isIncome ? Icons.attach_money : Icons.category,
              size: 64,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No custom ${isIncome ? 'income' : 'expense'} categories yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add your first category',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _buildCategoryCard(category);
      },
    );
  }

  Widget _buildCategoryCard(CustomCategory category) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Row(
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
                  category.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  category.isIncomeCategory ? 'Income' : 'Expense',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _editCategory(category),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 18),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _deleteCategory(category),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.delete, color: Colors.red[300], size: 18),
                ),
              ),
            ],
          ),
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
        onPressed: _showAddCategoryDialog,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  // Dialog background color constant for consistency
  static const Color _dialogBg = Color(0xFF1E1E2E);
  static const double _dialogOpacity = 0.88;

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    IconData selectedIcon = _availableIcons.first;
    Color selectedColor = _availableColors.first;
    bool isIncome = _tabController.index == 1;

    showDialog(
      context: context,
<<<<<<< Updated upstream
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF2D2D3A),
          title: const Text(
            'Add Category',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Category Name',
                    labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.3),
=======
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            backgroundColor: _dialogBg.withValues(alpha: _dialogOpacity),
            title: const Text(
              'Add Category',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Category Name',
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
>>>>>>> Stashed changes
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Category Type',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              isIncome = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !isIncome
                                  ? const Color(
                                      0xFF667eea,
                                    ).withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: !isIncome
                                    ? const Color(0xFF667eea)
                                    : Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              'Expense',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: !isIncome
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              isIncome = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isIncome
                                  ? Colors.green.withValues(alpha: 0.3)
                                  : Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isIncome
                                    ? Colors.green
                                    : Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              'Income',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: isIncome
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Icon',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableIcons.map((icon) {
                      final isSelected = icon == selectedIcon;
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            selectedIcon = icon;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
<<<<<<< Updated upstream
                            color: !isIncome
                                ? const Color(0xFF667eea).withOpacity(0.3)
                                : Colors.white.withOpacity(0.1),
=======
                            color: isSelected
                                ? const Color(0xFF667eea).withValues(alpha: 0.3)
                                : Colors.white.withValues(alpha: 0.1),
>>>>>>> Stashed changes
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF667eea)
<<<<<<< Updated upstream
                                  : Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Expense',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: !isIncome
                                  ? FontWeight.bold
                                  : FontWeight.normal,
=======
                                  : Colors.transparent,
>>>>>>> Stashed changes
                            ),
                          ),
                          child: Icon(icon, color: Colors.white, size: 24),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Color',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableColors.map((color) {
                      final isSelected = color == selectedColor;
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
<<<<<<< Updated upstream
                            color: isIncome
                                ? Colors.green.withOpacity(0.3)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isIncome
                                  ? Colors.green
                                  : Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Income',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: isIncome
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Icon',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableIcons.map((icon) {
                    final isSelected = icon == selectedIcon;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = icon;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF667eea).withOpacity(0.3)
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF667eea)
                                : Colors.transparent,
                          ),
                        ),
                        child: Icon(icon, color: Colors.white, size: 24),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Color',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableColors.map((color) {
                    final isSelected = color == selectedColor;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
=======
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
>>>>>>> Stashed changes
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a category name'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  final result = await _categoryService.create(
                    name: nameController.text.trim(),
                    icon: selectedIcon,
                    color: selectedColor,
                    isIncomeCategory: isIncome,
                  );

                  if (!mounted) return;
                  if (result.isSuccess) {
                    Navigator.pop(context);
                    _loadCategories();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Category created successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result.errorMessage ?? 'Failed to create category',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
<<<<<<< Updated upstream
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a category name'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final result = await _categoryService.create(
                  name: nameController.text.trim(),
                  icon: selectedIcon,
                  color: selectedColor,
                  isIncomeCategory: isIncome,
                );

                if (result.isSuccess) {
                  Navigator.pop(context);
                  _loadCategories();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Category created successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result.errorMessage ?? 'Failed to create category',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
=======
>>>>>>> Stashed changes
        ),
      ),
    );
  }

  void _editCategory(CustomCategory category) {
    final nameController = TextEditingController(text: category.name);
    IconData selectedIcon = category.icon;
    Color selectedColor = category.color;
    bool isIncome = category.isIncomeCategory;

    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            backgroundColor: _dialogBg.withValues(alpha: _dialogOpacity),
            title: const Text(
              'Edit Category',
              style: TextStyle(color: Colors.white),
            ),
            content: SingleChildScrollView(
              child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Category Name',
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
                const Text(
                  'Category Type',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            isIncome = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: !isIncome
                                ? const Color(0xFF667eea).withOpacity(0.3)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: !isIncome
                                  ? const Color(0xFF667eea)
                                  : Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Expense',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: !isIncome
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setDialogState(() {
                            isIncome = true;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isIncome
                                ? Colors.green.withOpacity(0.3)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isIncome
                                  ? Colors.green
                                  : Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Income',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: isIncome
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Icon',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableIcons.map((icon) {
                    final isSelected = icon == selectedIcon;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedIcon = icon;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF667eea).withOpacity(0.3)
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF667eea)
                                : Colors.transparent,
                          ),
                        ),
                        child: Icon(icon, color: Colors.white, size: 24),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Select Color',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableColors.map((color) {
                    final isSelected = color == selectedColor;
                    return GestureDetector(
                      onTap: () {
                        setDialogState(() {
                          selectedColor = color;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
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
                if (nameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a category name'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final updatedCategory = category.copyWith(
                  name: nameController.text.trim(),
                  iconCodePoint: selectedIcon.codePoint,
                  colorValue: selectedColor.value,
                  isIncomeCategory: isIncome,
                );

                final result = await _categoryService.update(updatedCategory);

<<<<<<< Updated upstream
=======
                if (!mounted) return;
>>>>>>> Stashed changes
                if (result.isSuccess) {
                  Navigator.pop(context);
                  _loadCategories();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Category updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result.errorMessage ?? 'Failed to update category',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteCategory(CustomCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D3A),
        title: const Text(
          'Delete Category',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${category.name}"?',
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final result = await _categoryService.delete(category.id);

<<<<<<< Updated upstream
              if (result.isSuccess) {
                Navigator.pop(context);
                _loadCategories();
=======
                if (!mounted) return;
                if (result.isSuccess) {
                  Navigator.pop(context);
                  _loadCategories();
>>>>>>> Stashed changes
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Category deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      result.errorMessage ?? 'Failed to delete category',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
