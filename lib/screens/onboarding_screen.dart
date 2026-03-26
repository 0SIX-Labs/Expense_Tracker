import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../widgets/gradient_button.dart';
import '../widgets/glass_card.dart';
import '../services/services.dart';
import '../models/models.dart';
import '../core/core.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _freelanceController = TextEditingController();
  final TextEditingController _investmentController = TextEditingController();
  final TextEditingController _otherIncomeController = TextEditingController();

  // State variables
  int _selectedMonthStartDay = 1;
  String _selectedCurrency = 'USD';
  bool _isLoading = false;
<<<<<<< Updated upstream
=======
  String _selectedCurrency = '';
  String _deviceSuggestedCurrency = 'USD';
  String _selectedLanguage = 'en';

  final List<String> _languages = [
    'en',
    'es',
    'de',
    'fr',
    'pt',
    'ja',
    'ko',
    'ru',
    'hi',
  ];
  final Map<String, String> _languageNames = {
    'en': '🇬🇧 English',
    'es': '🇪🇸 Español',
    'de': '🇩🇪 Deutsch',
    'fr': '🇫🇷 Français',
    'pt': '🇵🇹 Português',
    'ja': '🇯🇵 日本語',
    'ko': '🇰🇷 한국어',
    'ru': '🇷🇺 Русский',
    'hi': '🇮🇳 हिन्दी',
  };
>>>>>>> Stashed changes

  final List<String> _currencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'CHF',
    'CNY',
    'INR',
    'BRL',
  ];

  late final List<OnboardingPage> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      OnboardingPage(
        title: 'Welcome to Expense Tracker',
        description:
            'Take control of your finances with our beautiful and intuitive expense tracking app.',
        icon: Icons.account_balance_wallet,
        gradientColors: [Color(0xFF667eea), Color(0xFF764ba2)],
      ),
      OnboardingPage(
        title: 'What should we call you?',
        description: 'Enter your name to personalize your experience.',
        icon: Icons.person,
        gradientColors: [Color(0xFFf093fb), Color(0xFFf5576c)],
        content: _buildNameInput(),
      ),
      OnboardingPage(
        title: 'When does your month start?',
        description:
            'Choose the day your billing cycle begins to track expenses accurately.',
        icon: Icons.calendar_today,
        gradientColors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
        content: _buildMonthStartSelector(),
      ),
      OnboardingPage(
        title: 'Set your monthly income',
        description:
            'Enter your income sources to help plan your budget effectively.',
        icon: Icons.attach_money,
        gradientColors: [Color(0xFFFFB347), Color(0xFFFFCC80)],
        content: _buildIncomeInput(),
      ),
      OnboardingPage(
        title: 'Select your currency',
        description: 'Choose the currency you want to use for tracking.',
        icon: Icons.currency_exchange,
        gradientColors: [Color(0xFF667eea), Color(0xFF764ba2)],
        content: _buildCurrencySelector(),
        isLastPage: true,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _salaryController.dispose();
    _freelanceController.dispose();
    _investmentController.dispose();
    _otherIncomeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipToEnd() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter your name');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create user profile
      final userProfileService = UserProfileService();
      final profileResult = await userProfileService.createOrUpdate(
        name: _nameController.text.trim(),
        monthStartDay: _selectedMonthStartDay,
        defaultCurrency: _selectedCurrency,
      );

      if (profileResult.isFailure) {
        _showError(profileResult.errorMessage ?? 'Failed to save profile');
        return;
      }

      // Create income entries if provided
      final incomeService = IncomeService();
      final now = DateTime.now();

      if (_salaryController.text.trim().isNotEmpty) {
        final amount = double.tryParse(_salaryController.text.trim());
        if (amount != null && amount > 0) {
          await incomeService.create(
            amount: amount,
            category: IncomeCategory.salary,
            month: now.month,
            year: now.year,
          );
        }
      }

      if (_freelanceController.text.trim().isNotEmpty) {
        final amount = double.tryParse(_freelanceController.text.trim());
        if (amount != null && amount > 0) {
          await incomeService.create(
            amount: amount,
            category: IncomeCategory.freelance,
            month: now.month,
            year: now.year,
          );
        }
      }

      if (_investmentController.text.trim().isNotEmpty) {
        final amount = double.tryParse(_investmentController.text.trim());
        if (amount != null && amount > 0) {
          await incomeService.create(
            amount: amount,
            category: IncomeCategory.investment,
            month: now.month,
            year: now.year,
          );
        }
      }

      if (_otherIncomeController.text.trim().isNotEmpty) {
        final amount = double.tryParse(_otherIncomeController.text.trim());
        if (amount != null && amount > 0) {
          await incomeService.create(
            amount: amount,
            category: IncomeCategory.other,
            customCategoryName: 'Other Income',
            month: now.month,
            year: now.year,
          );
        }
      }

      // Mark onboarding as complete
      final box = await Hive.openBox(AppConstants.boxAppSettings);
      await box.put(AppConstants.keyHasCompletedOnboarding, true);

      AppLogger.info('Onboarding completed successfully', tag: 'Onboarding');

      // Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to complete onboarding',
        error: e,
        stackTrace: stackTrace,
      );
      _showError('An error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
<<<<<<< Updated upstream
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: _skipToEnd,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              // Page indicators
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildPageIndicator(index),
=======
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    physics: _currentPage == 0 || _currentPage == 1
                        ? const NeverScrollableScrollPhysics()
                        : const ClampingScrollPhysics(),
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      return _buildPage(_pages[index]);
                    },
>>>>>>> Stashed changes
                  ),
                ),

<<<<<<< Updated upstream
              const SizedBox(height: 32),

              // Next/Get Started button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GradientButton(
                  text: _currentPage == _pages.length - 1
                      ? 'Get Started'
                      : 'Next',
                  onPressed: _isLoading ? () {} : _nextPage,
                  isLoading: _isLoading,
                  gradientColors: _pages[_currentPage].gradientColors,
                  width: double.infinity,
=======
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _buildPageIndicator(index),
                    ),
                  ),
>>>>>>> Stashed changes
                ),

                const SizedBox(height: 32),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GradientButton(
                    text: _currentPage == _pages.length - 1
                        ? l10n.getStarted
                        : l10n.next,
                    onPressed: _isLoading ? () {} : _nextPage,
                    isLoading: _isLoading,
                    gradientColors: _pages[_currentPage].gradientColors,
                    width: double.infinity,
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
<<<<<<< Updated upstream
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: page.gradientColors),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: page.gradientColors.first.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(page.icon, color: Colors.white, size: 60),
          ),

          const SizedBox(height: 48),

          // Title
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),

          const SizedBox(height: 32),

          // Custom content
          if (page.content != null) page.content!,
        ],
      ),
    );
  }

=======
    final pageIndex = _pages.indexOf(page);
    final isLanguageCurrencyPage = pageIndex == 0 || pageIndex == 1;
    final isCalendarPage = pageIndex == 4;
    final isFormPage = pageIndex >= 2 && pageIndex <= 3;
    final iconSize = isCalendarPage
        ? 40.0
        : (isLanguageCurrencyPage ? 50.0 : (isFormPage ? 50.0 : 120.0));
    final iconIconSize = isCalendarPage
        ? 20.0
        : (isLanguageCurrencyPage ? 26.0 : (isFormPage ? 26.0 : 60.0));
    final borderRadius = (isLanguageCurrencyPage || isCalendarPage)
        ? 12.0
        : (isFormPage ? 15.0 : 30.0);
    final spacingAfterIcon = isFormPage ? 24.0 : 48.0;
    final shadowBlur = (isLanguageCurrencyPage || isCalendarPage)
        ? 10.0
        : (isFormPage ? 10.0 : 20.0);
    final shadowOpacity = (isLanguageCurrencyPage || isCalendarPage)
        ? 0.3
        : (isFormPage ? 0.2 : 0.3);
    final shadowOffsetY = (isLanguageCurrencyPage || isCalendarPage)
        ? 4.0
        : (isFormPage ? 4.0 : 10.0);

    // All pages use LayoutBuilder and ConstrainedBox for consistent constraints
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLanguageCurrencyPage) ...[
                  const SizedBox(height: 20),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: page.gradientColors),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: page.gradientColors.first.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(page.icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    page.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    page.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 44),
                  SizedBox(
                    height: 200,
                    child: Transform.translate(
                      offset: const Offset(-20, 0),
                      child: page.content ?? const SizedBox.shrink(),
                    ),
                  ),
                ] else ...[
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: page.gradientColors),
                      borderRadius: BorderRadius.circular(borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: page.gradientColors.first.withValues(
                            alpha: shadowOpacity,
                          ),
                          blurRadius: shadowBlur,
                          offset: Offset(0, shadowOffsetY),
                        ),
                      ],
                    ),
                    child: Icon(
                      page.icon,
                      color: Colors.white,
                      size: iconIconSize,
                    ),
                  ),
                  SizedBox(height: spacingAfterIcon),
                  Text(
                    page.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    page.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (page.content != null) page.content!,
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageSelector() {
    final selectedIndex = _languages.indexOf(_selectedLanguage);

    return SizedBox(
      height: 180,
      child: CupertinoPicker(
        itemExtent: 100,
        scrollController: FixedExtentScrollController(
          initialItem: selectedIndex,
        ),
        onSelectedItemChanged: (index) {
          final newLang = _languages[index];
          setState(() {
            _selectedLanguage = newLang;
          });
          // Update locale and rebuild widget to reflect language change
          final localeProvider = Provider.of<LocaleProvider>(
            context,
            listen: false,
          );
          localeProvider.setLocale(newLang);
        },
        children: _languages.map((lang) {
          return Center(
            child: Text(
              _languageNames[lang] ?? lang,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w700,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCurrencySelector() {
    final selectedIndex = _currencies.indexOf(_selectedCurrency);

    return SizedBox(
      height: 180,
      child: CupertinoPicker(
        itemExtent: 100,
        scrollController: FixedExtentScrollController(
          initialItem: selectedIndex,
        ),
        onSelectedItemChanged: (index) {
          setState(() {
            _selectedCurrency = _currencies[index];
          });
        },
        children: _currencies.map((currency) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                '${_getCurrencySymbol(currency)}  $currency',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

>>>>>>> Stashed changes
  Widget _buildNameInput() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Name',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              hintText: 'Enter your name',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthStartSelector() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Month Start Day',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your billing cycle will start on day $_selectedMonthStartDay of each month',
            style: TextStyle(
              fontSize: 14,
<<<<<<< Updated upstream
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: _selectedMonthStartDay.toDouble(),
            min: 1,
            max: 28,
            divisions: 27,
            activeColor: Colors.white,
            inactiveColor: Colors.white.withOpacity(0.3),
            onChanged: (value) {
              setState(() {
                _selectedMonthStartDay = value.round();
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Day 1',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
              Text(
                'Day 28',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
=======
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Day picker wheel
          SizedBox(
            height: 120,
            child: CupertinoPicker(
              itemExtent: 40,
              scrollController: FixedExtentScrollController(
                initialItem: _selectedMonthStartDay - 1,
              ),
              onSelectedItemChanged: (index) {
                setState(() {
                  _selectedMonthStartDay = index + 1;
                });
              },
              children: List.generate(31, (index) {
                final day = index + 1;
                return Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: day == _selectedMonthStartDay
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      fontSize: 22,
                      fontWeight: day == _selectedMonthStartDay
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                );
              }),
            ),
>>>>>>> Stashed changes
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeInput() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
<<<<<<< Updated upstream
          const Text(
            'Monthly Income Sources',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
=======
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  l10n.monthlyIncomeSources,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$currencySymbol $_selectedCurrency',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ],
>>>>>>> Stashed changes
          ),
          const SizedBox(height: 16),
          _buildIncomeField('Salary', _salaryController),
          const SizedBox(height: 12),
          _buildIncomeField('Freelance', _freelanceController),
          const SizedBox(height: 12),
          _buildIncomeField('Investment', _investmentController),
          const SizedBox(height: 12),
          _buildIncomeField('Other', _otherIncomeController),
        ],
      ),
    );
  }

  Widget _buildIncomeField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            prefixText: '\$ ',
            prefixStyle: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
            hintText: '0.00',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencySelector() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
<<<<<<< Updated upstream
          const Text(
            'Select Currency',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _currencies.map((currency) {
              final isSelected = _selectedCurrency == currency;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCurrency = currency;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          )
                        : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    currency,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
=======
          // Privacy Features
          _buildFeatureRow(
            icon: Icons.lock_outline,
            title: l10n.fullyPrivate,
            description: l10n.allDataStaysOnDevice,
          ),

          const SizedBox(height: 16),

          _buildFeatureRow(
            icon: Icons.cloud_off,
            title: l10n.noBackend,
            description: l10n.noServerNoAccount,
          ),

          const SizedBox(height: 16),

          _buildFeatureRow(
            icon: Icons.security,
            title: l10n.fullyOffline,
            description: l10n.worksWithoutInternet,
          ),

          const SizedBox(height: 16),

          _buildFeatureRow(
            icon: Icons.speed,
            title: l10n.lightningFast,
            description: l10n.instantAccessNoLoading,
>>>>>>> Stashed changes
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 32 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradientColors;
  final bool isLastPage;
  final Widget? content;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradientColors,
    this.isLastPage = false,
    this.content,
  });
}
