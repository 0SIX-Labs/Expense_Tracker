import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'config/config.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/services.dart';
import 'core/core.dart';
import 'models/models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize production environment
  EnvironmentManager.initialize(AppEnvironment.production);

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive TypeAdapters
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(IncomeAdapter());
  Hive.registerAdapter(IncomeCategoryAdapter());
  Hive.registerAdapter(CustomCategoryAdapter());
  Hive.registerAdapter(BudgetAdapter());
  Hive.registerAdapter(BudgetPeriodAdapter());
  Hive.registerAdapter(ExpenseAdapter());

  // Open app_settings box first (required by ThemeProvider)
  await Hive.openBox(AppConstants.boxAppSettings);

  // Open other Hive boxes
  await Hive.openBox<UserProfile>(AppConstants.boxUserProfile);
  await Hive.openBox<Income>(AppConstants.boxIncomes);
  await Hive.openBox<CustomCategory>(AppConstants.boxCustomCategories);
  await Hive.openBox<Budget>(AppConstants.boxBudgets);
  await Hive.openBox<Expense>(AppConstants.boxExpenses);

  // Initialize Storage Service
  final storageService = StorageService();
  await storageService.initialize();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Log app start
  AppLogger.info(
    'App started in ${EnvironmentManager.environment.name} mode',
    tag: 'Main',
  );

  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: EnvironmentManager.config.appName,
            debugShowCheckedModeBanner:
                EnvironmentManager.config.showDebugBanner,
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const AppInitializer(),
          );
        },
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isFirstTime = true;
  bool _isLoading = true;
  bool _hasUserProfile = false;

  @override
  void initState() {
    super.initState();
    _checkInitializationStatus();
  }

  Future<void> _checkInitializationStatus() async {
    try {
      final box = Hive.box(AppConstants.boxAppSettings);
      final hasCompletedOnboarding = box.get(
        AppConstants.keyHasCompletedOnboarding,
        defaultValue: false,
      );

      // Check if user profile exists
      final userProfileService = UserProfileService();
      final profileResult = await userProfileService.exists();
      final hasProfile = profileResult.isSuccess && profileResult.data == true;

      setState(() {
        _isFirstTime = !hasCompletedOnboarding;
        _hasUserProfile = hasProfile;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to check initialization status',
        error: e,
        stackTrace: stackTrace,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // If first time or no user profile, show onboarding
    if (_isFirstTime || !_hasUserProfile) {
      return const OnboardingScreen();
    }

    return const HomeScreen();
  }
}
