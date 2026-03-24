import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'config/config.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/services.dart';
import 'core/core.dart';
import 'generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize development environment
  EnvironmentManager.initialize(AppEnvironment.development);

  // Initialize Hive
  await Hive.initFlutter();

  // Open app_settings box first (required by ThemeProvider)
  await Hive.openBox(AppConstants.boxAppSettings);

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
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('es'),
              Locale('de'),
              Locale('fr'),
              Locale('pt'),
              Locale('ja'),
              Locale('ko'),
              Locale('ru'),
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return const Locale('en');
            },
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

  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    try {
      final box = Hive.box(AppConstants.boxAppSettings);
      final hasCompletedOnboarding = box.get(
        AppConstants.keyHasCompletedOnboarding,
        defaultValue: false,
      );

      setState(() {
        _isFirstTime = !hasCompletedOnboarding;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to check onboarding status',
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

    return _isFirstTime ? const OnboardingScreen() : const HomeScreen();
  }
}
