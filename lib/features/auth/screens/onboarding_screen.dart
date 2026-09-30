// lib/features/auth/screens/onboarding_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/widgets/primary_button.dart';
import 'package:fintrack/features/auth/services/auth_service.dart';
import 'package:fintrack/features/auth/widgets/pin_input_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSettingPin = false;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Track Every Shilling',
      'subtitle': 'Easily record cash, M-Pesa, Tigo Pesa, and bank transactions in one place.',
      'icon': 'payments',
    },
    {
      'title': 'Smart Monthly Budgets',
      'subtitle': 'Set category budgets and get alerts before you overspend.',
      'icon': 'pie_chart',
    },
    {
      'title': 'Reach Your Financial Goals',
      'subtitle': 'Save for emergencies, business capital, or school fees effortlessly.',
      'icon': 'flag',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      setState(() {
        _isSettingPin = true;
      });
    }
  }

  Future<void> _handlePinCompleted(String pin) async {
    final authService = context.read<AuthService>();
    await authService.setPin(pin);
    await authService.completeOnboarding();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> _handleSkipPin() async {
    final authService = context.read<AuthService>();
    await authService.completeOnboarding();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isSettingPin) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Set Security PIN'),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Spacer(),
                Text(
                  'Secure Your FinTrack',
                  style: AppTextStyles.sectionTitle(
                    context,
                    isDark: isDark,
                  ).copyWith(fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter a 4-digit PIN to protect your financial data.',
                  style: AppTextStyles.body(context, isDark: isDark).copyWith(
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                PinInputWidget(onCompleted: _handlePinCompleted),
                const Spacer(),
                TextButton(
                  onPressed: _handleSkipPin,
                  child: Text(
                    'Skip for now',
                    style: AppTextStyles.body(context, isDark: isDark).copyWith(
                      color: AppColors.primaryAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _isSettingPin = true;
                    });
                  },
                  child: Text(
                    'Skip',
                    style: AppTextStyles.body(context, isDark: isDark).copyWith(
                      color: isDark
                          ? AppColors.darkSecondaryText
                          : AppColors.lightSecondaryText,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent.withValues(
                              alpha: 0.15,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            index == 0
                                ? Icons.payments
                                : index == 1
                                ? Icons.pie_chart
                                : Icons.flag,
                            size: 64,
                            color: AppColors.primaryAccent,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slide['title']!,
                          style: AppTextStyles.sectionTitle(
                            context,
                            isDark: isDark,
                          ).copyWith(fontSize: 24),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide['subtitle']!,
                          style: AppTextStyles.body(context, isDark: isDark)
                              .copyWith(
                                color: isDark
                                    ? AppColors.darkSecondaryText
                                    : AppColors.lightSecondaryText,
                                fontSize: 16,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _slides.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primaryAccent
                          : AppColors.lightBorder,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: _currentPage == _slides.length - 1
                    ? 'Set PIN & Start'
                    : 'Next',
                onPressed: _onNextPressed,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
