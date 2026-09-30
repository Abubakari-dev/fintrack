// lib/app.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintrack/core/constants/app_constants.dart';
import 'package:fintrack/core/theme/app_theme.dart';
import 'package:fintrack/core/routes/app_router.dart';
import 'package:fintrack/features/auth/services/auth_service.dart';

class FinTrackApp extends StatelessWidget {
  const FinTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: authService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
