import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import '../widgets/gradient_button.dart';
import '../widgets/glass_card.dart';
import '../services/services.dart';
import '../models/models.dart';
import '../core/core.dart';
import '../generated/app_localizations.dart';
import '../utils/locale_currency_mapper.dart';
import '../providers/locale_provider.dart';
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
  bool _isLoading = false;
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
  };

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

  late List<OnboardingPage> _pages;
  bool _pagesInitialized = false;
  String _lastCurrencyUsedForPages = '';

  @override
  void initState() {
    super.initState();
    _initializeDeviceCurrency();
    _pages = [];
  }

  void _initializeDeviceCurrency() {
    _deviceSuggestedCurrency = LocaleCurrencyMapper.getCurrencyFromLocale();
    _selectedCurrency = _deviceSuggestedCurrency;

    // Auto-detect device language
    final deviceLanguage = LocaleCurrencyMapper.getDeviceLanguage();
    if (_languages.contains(deviceLanguage)) {
      _selectedLanguage = deviceLanguage;
    }

    AppLogger.info(
      'Device detected: Language=$deviceLanguage, Suggested Currency=$_deviceSuggestedCurrency',
      tag: 'Onboarding',
    );
  }

  void _initializePages() {
    final l10n = AppLocalizations.of(context)!;
    _pages = [
      // Page 0: Language Selection
      OnboardingPage(
        title: 'Language',
        description: 'Choose your preferred language',
        icon: Icons.language,
        gradientColors: [Color(0xFF667eea), Color(0xFF764ba2)],
        content: _buildLanguageSelector(),
      ),
      // Page 1: Currency Selection
      OnboardingPage(
        title: 'Currency',
        description: 'Select your currency',
        icon: Icons.attach_money,
        gradientColors: [Color(0xFF667eea), Color(0xFF764ba2)],
        content: _buildCurrencySelector(),
      ),
      // Page 2: Name Entry
      OnboardingPage(
        title: l10n.personalizeExperience,
        description: 'Let\'s start by getting your name',
        icon: Icons.person,
        gradientColors: [Color(0xFFf093fb), Color(0xFFf5576c)],
        content: _buildNameInput(),
      ),
      // Page 3: Welcome
      OnboardingPage(
        title: 'Welcome to Fynz',
        description: 'Your personal expense tracker that works 100% offline',
        icon: Icons.account_balance_wallet,
        gradientColors: [Color(0xFF667eea), Color(0xFF764ba2)],
        content: _buildNativeAppInfo(),
      ),
      // Page 4: Month Start Day
      OnboardingPage(
        title: l10n.whenMonthStart,
        description: l10n.monthStartDescription,
        icon: Icons.calendar_today,
        gradientColors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
        content: _buildMonthStartSelector(),
      ),
      // Page 5: Income Setup (Last Page)
      OnboardingPage(
        title: l10n.setMonthlyIncome,
        description: l10n.monthlyIncomeDescription,
        icon: Icons.attach_money,
        gradientColors: [Color(0xFFFFB347), Color(0xFFFFCC80)],
        content: _buildIncomeInput(),
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
    // Validate name on page 2 (after language and currency)
    if (_currentPage == 2 && _nameController.text.trim().isEmpty) {
      _showError('Please enter your name to continue');
      return;
    }

    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
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
      if (!mounted) return;
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
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_pagesInitialized || _lastCurrencyUsedForPages != _selectedCurrency) {
      _initializePages();
      _pagesInitialized = true;
      _lastCurrencyUsedForPages = _selectedCurrency;
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
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  physics: _currentPage == 0 || _currentPage == 1
                      ? const NeverScrollableScrollPhysics()
                      : const AlwaysScrollableScrollPhysics(),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildPageIndicator(index),
                  ),
                ),
              ),

              const SizedBox(height: 32),

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
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    final isLanguageCurrencyPage = _currentPage == 0;
    final isFormPage = _currentPage >= 1 && _currentPage <= 3;
    final iconSize = isFormPage ? 60.0 : 120.0;
    final iconIconSize = isFormPage ? 32.0 : 60.0;
    final borderRadius = isFormPage ? 15.0 : 30.0;
    final spacingAfterIcon = isFormPage ? 24.0 : 48.0;
    final shadowBlur = isFormPage ? 10.0 : 20.0;
    final shadowOpacity = isFormPage ? 0.2 : 0.3;
    final shadowOffsetY = isFormPage ? 4.0 : 10.0;

    // Language & Currency page needs Column layout for Expanded to work
    if (isLanguageCurrencyPage) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: page.gradientColors),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: page.gradientColors.first.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.language, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 16),
            Text(
              page.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              page.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            if (page.content != null) Expanded(child: page.content!),
          ],
        ),
      );
    }

    // Other pages use SingleChildScrollView
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            child: Icon(page.icon, color: Colors.white, size: iconIconSize),
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
      ),
    );
  }

  Widget _buildLanguageSelector() {
    final selectedIndex = _languages.indexOf(_selectedLanguage);

    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Picker header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Language',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _languageNames[_selectedLanguage] ?? _selectedLanguage,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Picker separator
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.3),
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),

          // Cupertino picker
          Expanded(
            child: CupertinoPicker(
              itemExtent: 40,
              scrollController: FixedExtentScrollController(
                initialItem: selectedIndex,
              ),
              onSelectedItemChanged: (index) {
                final newLang = _languages[index];
                setState(() {
                  _selectedLanguage = newLang;
                });
                // Update locale immediately without page rebuild
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
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencySelector() {
    final selectedIndex = _currencies.indexOf(_selectedCurrency);

    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF667eea).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Picker header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Currency',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedCurrency != _deviceSuggestedCurrency
                      ? '$_selectedCurrency (Device: $_deviceSuggestedCurrency)'
                      : _selectedCurrency,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Picker separator
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.3),
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),

          // Cupertino picker
          Expanded(
            child: CupertinoPicker(
              itemExtent: 40,
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
                  child: Text(
                    currency,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    final l10n = AppLocalizations.of(context)!;
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.yourName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: l10n.pleaseEnterYourName,
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
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
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Text(
            'Billing Cycle Start',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your expense tracking cycle resets on this day each month',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Circular day selector
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4ECDC4).withValues(alpha: 0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Day',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$_selectedMonthStartDay',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
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
                    'Day $day',
                    style: TextStyle(
                      color: day == _selectedMonthStartDay
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      fontSize: 18,
                      fontWeight: day == _selectedMonthStartDay
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeInput() {
    final currencySymbol = _getCurrencySymbol(_selectedCurrency);
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Income Sources',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
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
    final currencySymbol = _getCurrencySymbol(_selectedCurrency);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            prefixText: '$currencySymbol ',
            prefixStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w600,
            ),
            hintText: '0.00',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  String _getCurrencySymbol(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'CAD':
        return 'C\$';
      case 'AUD':
        return 'A\$';
      case 'CHF':
        return 'CHF';
      case 'CNY':
        return '¥';
      case 'INR':
        return '₹';
      case 'BRL':
        return 'R\$';
      default:
        return '\$';
    }
  }

  Widget _buildNativeAppInfo() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Native App Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4ECDC4).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.phone_iphone, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Native Mobile App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Privacy Features
          _buildFeatureRow(
            icon: Icons.lock_outline,
            title: '100% Private',
            description: 'All data stays on your device',
          ),

          const SizedBox(height: 16),

          _buildFeatureRow(
            icon: Icons.cloud_off,
            title: 'No Backend',
            description: 'No server, no account needed',
          ),

          const SizedBox(height: 16),

          _buildFeatureRow(
            icon: Icons.security,
            title: 'Fully Offline',
            description: 'Works without internet',
          ),

          const SizedBox(height: 16),

          _buildFeatureRow(
            icon: Icons.speed,
            title: 'Lightning Fast',
            description: 'Instant access, no loading',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
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
        color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.4),
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
