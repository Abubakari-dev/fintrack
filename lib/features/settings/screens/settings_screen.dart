// lib/features/settings/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintrack/core/constants/app_constants.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/app_localizations.dart';
import 'package:fintrack/core/widgets/bottom_nav_bar.dart';
import 'package:fintrack/features/auth/services/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final int _currentIndex = 4;

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/history');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/goals');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/insights');
        break;
      case 4:
        break;
    }
  }

  void _showClearDataConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear All Data'),
          content: const Text(
            'Are you sure you want to clear all data and reset app settings? This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.expense,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                final authService = context.read<AuthService>();
                await authService.clearAllData();
                if (!mounted) return;
                if (dialogContext.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    dialogContext,
                    '/',
                    (route) => false,
                  );
                }
              },
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authService = context.watch<AuthService>();
    final loc = AppLocalizations(authService.languageCode);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('settings')),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            loc.translate('language'),
            style: AppTextStyles.sectionTitle(context, isDark: isDark),
          ),
          const SizedBox(height: 8),
          ListTile(
            title: Text(
              loc.translate('language'),
              style: AppTextStyles.body(context, isDark: isDark),
            ),
            subtitle: Text(
              authService.languageCode == 'sw' ? 'Kiswahili 🇹🇿' : 'English 🇬🇧',
              style: AppTextStyles.caption(context, isDark: isDark),
            ),
            trailing: DropdownButton<String>(
              value: authService.languageCode,
              items: const [
                DropdownMenuItem(value: 'sw', child: Text('Kiswahili')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (val) {
                if (val != null) {
                  authService.setLanguage(val);
                }
              },
            ),
          ),
          const Divider(height: 32),
          Text(
            'Appearance',
            style: AppTextStyles.sectionTitle(context, isDark: isDark),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: Text(
              loc.translate('darkMode'),
              style: AppTextStyles.body(context, isDark: isDark),
            ),
            subtitle: Text(
              'Switch between light and dark theme',
              style: AppTextStyles.caption(context, isDark: isDark),
            ),
            value: authService.isDarkMode,
            activeColor: AppColors.primaryAccent,
            onChanged: (val) {
              authService.setDarkMode(val);
            },
          ),
          const Divider(height: 32),
          Text(
            'Security',
            style: AppTextStyles.sectionTitle(context, isDark: isDark),
          ),
          const SizedBox(height: 8),
          ListTile(
            title: Text(
              authService.hasPinSet
                  ? 'Change or Remove PIN'
                  : loc.translate('securityPin'),
              style: AppTextStyles.body(context, isDark: isDark),
            ),
            subtitle: Text(
              authService.hasPinSet
                  ? 'PIN protection is active'
                  : 'Secure your app with a 4-digit PIN',
              style: AppTextStyles.caption(context, isDark: isDark),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(context, '/onboarding');
            },
          ),
          if (authService.hasPinSet)
            ListTile(
              title: Text(
                'Remove PIN',
                style: AppTextStyles.body(
                  context,
                  isDark: isDark,
                ).copyWith(color: AppColors.expense),
              ),
              onTap: () async {
                final messenger = ScaffoldMessenger.of(context);
                await authService.removePin();
                if (!mounted) return;
                messenger.showSnackBar(
                  const SnackBar(content: Text('PIN removed successfully')),
                );
              },
            ),
          const Divider(height: 32),
          Text(
            'Data Management',
            style: AppTextStyles.sectionTitle(context, isDark: isDark),
          ),
          const SizedBox(height: 8),
          ListTile(
            title: Text(
              loc.translate('clearData'),
              style: AppTextStyles.body(
                context,
                isDark: isDark,
              ).copyWith(color: AppColors.expense),
            ),
            subtitle: Text(
              'Delete all transactions, wallets, and goals',
              style: AppTextStyles.caption(context, isDark: isDark),
            ),
            onTap: () => _showClearDataConfirmation(context),
          ),
          const Divider(height: 32),
          Center(
            child: Text(
              '${AppConstants.appName} v${AppConstants.appVersion}\nMade for Young Tanzanians 🇹🇿',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(context, isDark: isDark),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
