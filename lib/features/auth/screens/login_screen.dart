// lib/features/auth/screens/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintrack/core/constants/app_constants.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/features/auth/services/auth_service.dart';
import 'package:fintrack/features/auth/widgets/pin_input_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _errorMessage;

  void _handlePinCompleted(String pin) {
    final authService = context.read<AuthService>();
    final isValid = authService.verifyPin(pin);
    if (isValid) {
      authService.setAuthenticated(true);
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = 'Incorrect PIN. Please try again.';
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _errorMessage = null;
          });
        }
      });
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryAccent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 48,
                  color: AppColors.primaryAccent,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome Back to ${AppConstants.appName}',
                style: AppTextStyles.sectionTitle(
                  context,
                  isDark: isDark,
                ).copyWith(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your 4-digit PIN to continue',
                style: AppTextStyles.body(context, isDark: isDark).copyWith(
                  color: isDark
                      ? AppColors.darkSecondaryText
                      : AppColors.lightSecondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: AppTextStyles.body(context, isDark: isDark).copyWith(
                    color: AppColors.expense,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              PinInputWidget(onCompleted: _handlePinCompleted),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
