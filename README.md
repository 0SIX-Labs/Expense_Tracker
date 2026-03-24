# Fynz - Budget & Expense Tracker

A beautiful, production-ready Flutter budget & expense tracking application with Liquid Glass design aesthetic.

**Bundle Identifier:** com.osixlabs.fynz

## Features

- **Expense Tracking**: Add, edit, delete, and categorize expenses
- **Budget Management**: Set budgets for different categories with period support (weekly, monthly, yearly)
- **Analytics**: Visual spending breakdown with charts and insights
- **Export**: Export data to CSV and PDF formats
- **Dark Mode**: Full dark/light theme support
- **Local Storage**: Persistent data storage using Hive
- **Beautiful UI**: Liquid Glass design with glassmorphism effects

## Project Structure

```
lib/
├── config/                    # Environment configurations
│   ├── app_environment.dart   # Environment enum and config class
│   ├── env_development.dart   # Development environment config
│   ├── env_uat.dart           # UAT environment config
│   ├── env_production.dart    # Production environment config
│   └── environment_manager.dart # Environment manager
├── core/                      # Core utilities and constants
│   ├── exceptions/            # Custom exceptions
│   ├── utils/                 # Utility classes (Result, Logger)
│   └── constants/             # App-wide constants
├── models/                    # Data models
│   ├── expense.dart           # Expense model with Hive support
│   ├── budget.dart            # Budget model with Hive support
│   └── category.dart          # Category model
├── providers/                 # State management
│   └── theme_provider.dart    # Theme state management
├── screens/                   # UI screens
│   ├── onboarding_screen.dart # Onboarding flow
│   ├── home_screen.dart       # Main home screen
│   ├── add_expense_screen.dart # Add/Edit expense
│   ├── budget_screen.dart     # Budget management
│   ├── budget_setup_screen.dart # Initial budget setup
│   ├── analytics_screen.dart  # Analytics and charts
│   └── settings_screen.dart   # App settings
├── services/                  # Business logic services
│   ├── storage_service.dart   # Hive storage abstraction
│   ├── expense_service.dart   # Expense CRUD operations
│   ├── budget_service.dart    # Budget CRUD operations
│   ├── export_service.dart    # CSV/PDF export
│   └── analytics_service.dart # Analytics calculations
├── widgets/                   # Reusable widgets
│   ├── expense_card.dart      # Expense display card
│   ├── glass_card.dart        # Glassmorphism card
│   └── gradient_button.dart   # Gradient button
├── main.dart                  # Default entry point (production)
├── main_dev.dart              # Development entry point
├── main_uat.dart              # UAT entry point
└── main_prod.dart             # Production entry point
```

## Environments

This app supports three environments with different configurations:

### Development (`main_dev.dart`)
- App Name: "Fynz (Dev)"
- Debug Banner: Shown
- Logging: Verbose
- Analytics: Disabled
- Hive Prefix: `dev_`

### UAT (`main_uat.dart`)
- App Name: "Fynz (UAT)"
- Debug Banner: Hidden
- Logging: Info only
- Analytics: Enabled
- Hive Prefix: `uat_`

### Production (`main_prod.dart`)
- App Name: "Fynz - Budget & Expense Tracker"
- Debug Banner: Hidden
- Logging: Errors only
- Analytics: Enabled
- Hive Prefix: None

## Running the App

### Development Environment
```bash
flutter run -t lib/main_dev.dart
```

### UAT Environment
```bash
flutter run -t lib/main_uat.dart
```

### Production Environment
```bash
flutter run -t lib/main_prod.dart
# or simply:
flutter run
```

## Building the App

### Android

**Development:**
```bash
flutter build apk -t lib/main_dev.dart --flavor dev
```

**UAT:**
```bash
flutter build apk -t lib/main_uat.dart --flavor uat
```

**Production:**
```bash
flutter build appbundle -t lib/main_prod.dart --flavor prod
```

### iOS

**Development:**
```bash
flutter build ios -t lib/main_dev.dart --flavor Development
```

**UAT:**
```bash
flutter build ios -t lib/main_uat.dart --flavor UAT
```

**Production:**
```bash
flutter build ios -t lib/main_prod.dart --flavor Production
```

## Architecture

### State Management
- **Provider**: Used for theme management
- **Services**: Singleton services for business logic
- **Result Pattern**: Type-safe error handling with `Result<T, E>`

### Data Persistence
- **Hive**: Local NoSQL database for offline storage
- **TypeAdapters**: Generated adapters for model serialization

### Error Handling
- **Custom Exceptions**: App-specific exception types
- **Result Type**: Encapsulates success/failure states
- **Logging**: Environment-aware logging with `AppLogger`

## Testing

Run all tests:
```bash
flutter test
```

Run specific test file:
```bash
flutter test test/services/expense_service_test.dart
```

## Dependencies

### State Management
- `provider: ^6.1.1`

### Local Database
- `hive: ^2.2.3`
- `hive_flutter: ^1.1.0`

### Charts and Visualization
- `fl_chart: ^0.66.0`

### Date and Time
- `intl: ^0.18.1`

### UUID Generation
- `uuid: ^4.2.1`

### File System
- `path_provider: ^2.1.1`

### Export Functionality
- `csv: ^5.1.1`
- `pdf: ^3.10.7`
- `share_plus: ^7.2.1`

### UI Effects
- `glassmorphism: ^3.0.0`
- `flutter_animate: ^4.3.0`
- `shimmer: ^3.0.0`
- `blur: ^3.1.0`

### Icons
- `font_awesome_flutter: ^10.6.0`

## Code Generation

Generate Hive TypeAdapters:
```bash
flutter pub run build_runner build
```

## Design System

The app uses a "Liquid Glass" design aesthetic featuring:
- Glassmorphism effects with blur and transparency
- Gradient backgrounds (Purple → Pink → Blue)
- Smooth animations and transitions
- Consistent border radius (20px for cards)
- Semi-transparent overlays

### Color Palette
- Primary Gradient: `#667eea` → `#764ba2` → `#f093fb`
- Scaffold Background: `#F5F5F5` (light) / `#121212` (dark)

### Category Colors
| Category | Color |
|----------|-------|
| Food & Dining | `#FF6B6B` |
| Transport | `#4ECDC4` |
| Shopping | `#FFB347` |
| Entertainment | `#9B59B6` |
| Bills & Utilities | `#3498DB` |
| Healthcare | `#E74C3C` |
| Education | `#2ECC71` |
| Travel | `#1ABC9C` |
| Groceries | `#95A5A6` |
| Other | `#7F8C8D` |

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Hive team for the efficient local database
- fl_chart team for beautiful charts