// lib/main.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fintrack/app.dart';
import 'package:fintrack/core/database/db_helper.dart';
import 'package:fintrack/features/auth/services/auth_service.dart';
import 'package:fintrack/features/expense/services/expense_service.dart';
import 'package:fintrack/features/income/services/income_service.dart';
import 'package:fintrack/features/savings/services/savings_service.dart';
import 'package:fintrack/features/budget/services/budget_service.dart';
import 'package:fintrack/features/wallet/services/wallet_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FFI for desktop platforms (Windows, Linux, macOS)
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Initialize SQLite Database
  await DbHelper.instance.database;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()..initAuth()),
        ChangeNotifierProvider(create: (_) => ExpenseService()..loadExpenses()),
        ChangeNotifierProvider(create: (_) => IncomeService()..loadIncomes()),
        ChangeNotifierProvider(create: (_) => SavingsService()..loadGoals()),
        ChangeNotifierProvider(create: (_) => BudgetService()),
        ChangeNotifierProvider(create: (_) => WalletService()..loadWallets()),
      ],
      child: const FinTrackApp(),
    ),
  );
}
