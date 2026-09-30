// lib/core/routes/app_router.dart

import 'package:flutter/material.dart';
import 'package:fintrack/features/home/screens/splash_screen.dart';
import 'package:fintrack/features/home/screens/home_screen.dart';
import 'package:fintrack/features/auth/screens/onboarding_screen.dart';
import 'package:fintrack/features/auth/screens/login_screen.dart';
import 'package:fintrack/features/expense/screens/add_expense_screen.dart';
import 'package:fintrack/features/expense/screens/history_screen.dart';
import 'package:fintrack/features/income/screens/add_income_screen.dart';
import 'package:fintrack/features/savings/screens/goals_screen.dart';
import 'package:fintrack/features/budget/screens/budget_screen.dart';
import 'package:fintrack/features/insights/screens/insights_screen.dart';
import 'package:fintrack/features/wallet/screens/wallet_screen.dart';
import 'package:fintrack/features/settings/screens/settings_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String addExpense = '/add_expense';
  static const String addIncome = '/add_income';
  static const String history = '/history';
  static const String goals = '/goals';
  static const String budget = '/budget';
  static const String insights = '/insights';
  static const String wallets = '/wallets';
  static const String settings = '/settings';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case addExpense:
        return MaterialPageRoute(builder: (_) => const AddExpenseScreen());
      case addIncome:
        return MaterialPageRoute(builder: (_) => const AddIncomeScreen());
      case history:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());
      case goals:
        return MaterialPageRoute(builder: (_) => const GoalsScreen());
      case budget:
        return MaterialPageRoute(builder: (_) => const BudgetScreen());
      case insights:
        return MaterialPageRoute(builder: (_) => const InsightsScreen());
      case wallets:
        return MaterialPageRoute(builder: (_) => const WalletScreen());
      case AppRouter.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
