// lib/core/theme/app_text_styles.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Large Amounts (28 - 32px bold)
  static TextStyle largeAmount(BuildContext context, {bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: isDark ? const Color(0xFFF3F4F6) : const Color(0xFF111111),
    );
  }

  // Section Titles (18 - 20px bold)
  static TextStyle sectionTitle(BuildContext context, {bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: isDark ? const Color(0xFFF3F4F6) : const Color(0xFF111111),
    );
  }

  // Body Regular/Medium (14 - 16px)
  static TextStyle body(BuildContext context, {bool isDark = false, FontWeight fontWeight = FontWeight.normal}) {
    return GoogleFonts.inter(
      fontSize: 15,
      fontWeight: fontWeight,
      color: isDark ? const Color(0xFFF3F4F6) : const Color(0xFF111111),
    );
  }

  // Captions & Secondary Text (12px, secondary color)
  static TextStyle caption(BuildContext context, {bool isDark = false}) {
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B6B6B),
    );
  }

  // Button text
  static TextStyle buttonText(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
  }
}
