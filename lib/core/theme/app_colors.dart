// lib/core/theme/app_colors.dart

import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color lightBackground = Color(0xFFFAFAF8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightPrimaryText = Color(0xFF111111);
  static const Color lightSecondaryText = Color(0xFF6B6B6B);
  static const Color lightBorder = Color(0xFFE5E5E2);

  // Dark Theme Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkPrimaryText = Color(0xFFF3F4F6);
  static const Color darkSecondaryText = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF2D2D2D);

  // Universal Brand & Status Colors
  static const Color primaryAccent = Color(0xFF0F766E); // Deep Emerald / Teal
  static const Color primaryAccentDark = Color(0xFF14B8A6);
  static const Color expense = Color(0xFFDC2626); // Red
  static const Color success = Color(0xFF16A34A); // Green (Under budget / savings / income)
  static const Color warning = Color(0xFFF59E0B); // Amber (Budget close to limit)
}
