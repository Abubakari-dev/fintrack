// lib/features/home/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintrack/core/constants/app_constants.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/widgets/primary_button.dart';
import 'package:fintrack/features/auth/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authService = context.read<AuthService>();
    await authService.initAuth();
  }

  void _handleGetStarted() {
    final authService = context.read<AuthService>();
    if (!authService.isOnboardingCompleted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else if (authService.hasPinSet) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  size: 64,
                  color: AppColors.primaryAccent,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppConstants.appName,
                style: AppTextStyles.largeAmount(
                  context,
                  isDark: isDark,
                ).copyWith(fontSize: 36, color: AppColors.primaryAccent),
              ),
              const SizedBox(height: 12),
              Text(
                AppConstants.appTagline,
                textAlign: TextAlign.center,
                style: AppTextStyles.body(context, isDark: isDark).copyWith(
                  color: isDark
                      ? AppColors.darkSecondaryText
                      : AppColors.lightSecondaryText,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              PrimaryButton(text: 'Get Started', onPressed: _handleGetStarted),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
