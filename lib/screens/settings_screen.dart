import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../services/services.dart';
import '../models/models.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../core/core.dart';
import 'category_management_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final UserProfileService _userProfileService = UserProfileService();
  String _selectedCurrency = 'USD';
  bool _notifications = true;
  String _userName = 'User';
  int _monthStartDay = 1;
  bool _isLoading = true;

  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD'];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final profileResult = await _userProfileService.get();
      if (profileResult.isSuccess && profileResult.data != null) {
        final profile = profileResult.data!;
        setState(() {
          _userName = profile.name;
          _selectedCurrency = profile.defaultCurrency;
          _monthStartDay = profile.monthStartDay;
        });
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to load user data',
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),

          // Header
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Customize your experience',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 24),

          // Profile Section
          _buildProfileSection(),
          const SizedBox(height: 16),

          // Category Management
          _buildCategoryManagement(),
          const SizedBox(height: 16),

          // Currency Selection
          _buildCurrencySelector(),
          const SizedBox(height: 16),

          // Month Start Day
          _buildMonthStartDaySelector(),
          const SizedBox(height: 16),

          // Dark Mode Toggle
          _buildDarkModeToggle(),
          const SizedBox(height: 16),

          // Notifications Toggle
          _buildNotificationsToggle(),
          const SizedBox(height: 24),

          // Export Data
          _buildExportSection(),
          const SizedBox(height: 16),

          // About Section
          _buildAboutSection(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF667eea),
                child: Text(
                  _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Month starts on day $_monthStartDay',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _showEditProfileDialog,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryManagement() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9B59B6), Color(0xFFBB8FCE)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.category,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Create and manage custom expense and income categories',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          GradientButton(
            text: 'Manage Categories',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoryManagementScreen(),
                ),
              );
            },
            gradientColors: const [Color(0xFF9B59B6), Color(0xFFBB8FCE)],
            icon: const Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencySelector() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.attach_money,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Currency',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _currencies.map((currency) {
              final isSelected = _selectedCurrency == currency;
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    _selectedCurrency = currency;
                  });
                  // Update user profile
                  final profileResult = await _userProfileService.get();
                  if (profileResult.isSuccess && profileResult.data != null) {
                    await _userProfileService.updateDefaultCurrency(currency);
                  }
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
          ),
        ],
      ),
    );
  }

  Widget _buildMonthStartDaySelector() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Month Start Day',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Your billing cycle starts on day $_monthStartDay of each month',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: _monthStartDay.toDouble(),
            min: 1,
            max: 28,
            divisions: 27,
            activeColor: Colors.white,
            inactiveColor: Colors.white.withOpacity(0.3),
            onChanged: (value) async {
              setState(() {
                _monthStartDay = value.round();
              });
              // Update user profile
              final profileResult = await _userProfileService.get();
              if (profileResult.isSuccess && profileResult.data != null) {
                await _userProfileService.updateMonthStartDay(_monthStartDay);
              }
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
          ),
        ],
      ),
    );
  }

  Widget _buildDarkModeToggle() {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return GlassCard(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFf5576c), Color(0xFFf093fb)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Enable dark theme',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleDarkMode(value);
                },
                activeThumbColor: Colors.white,
                activeTrackColor: const Color(0xFF667eea).withOpacity(0.5),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationsToggle() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.notifications,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Get budget alerts and reminders',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _notifications,
            onChanged: (value) {
              setState(() {
                _notifications = value;
              });
            },
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF4ECDC4).withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildExportSection() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFB347), Color(0xFFFFCC80)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.download,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Export Data',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GradientButton(
                  text: 'Export CSV',
                  onPressed: () {
                    _showExportDialog('CSV');
                  },
                  gradientColors: const [Color(0xFF2ECC71), Color(0xFF27AE60)],
                  height: 44,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GradientButton(
                  text: 'Export PDF',
                  onPressed: () {
                    _showExportDialog('PDF');
                  },
                  gradientColors: const [Color(0xFFE74C3C), Color(0xFFC0392B)],
                  height: 44,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.info, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildAboutItem('Version', '1.0.0'),
          _buildAboutItem('Developer', 'Expense Tracker Team'),
          _buildAboutItem('License', 'MIT'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _showPrivacyDialog();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Privacy Policy',
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
                  onTap: () {
                    _showTermsDialog();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Terms of Service',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _userName);
    int selectedMonthStartDay = _monthStartDay;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF2D2D3A),
          title: const Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Your Name',
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
                'Month Start Day',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Slider(
                value: selectedMonthStartDay.toDouble(),
                min: 1,
                max: 28,
                divisions: 27,
                activeColor: Colors.white,
                inactiveColor: Colors.white.withOpacity(0.3),
                onChanged: (value) {
                  setDialogState(() {
                    selectedMonthStartDay = value.round();
                  });
                },
              ),
              Text(
                'Day $selectedMonthStartDay',
                style: const TextStyle(color: Colors.white),
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
                if (nameController.text.trim().isNotEmpty) {
                  final result = await _userProfileService.createOrUpdate(
                    name: nameController.text.trim(),
                    monthStartDay: selectedMonthStartDay,
                    defaultCurrency: _selectedCurrency,
                  );

                  if (result.isSuccess) {
                    setState(() {
                      _userName = nameController.text.trim();
                      _monthStartDay = selectedMonthStartDay;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          result.errorMessage ?? 'Failed to update profile',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog(String format) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export $format'),
        content: Text('$format export feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text('Privacy policy details will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const Text('Terms of service details will be available soon.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
