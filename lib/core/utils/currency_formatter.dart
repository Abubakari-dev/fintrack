// lib/core/utils/currency_formatter.dart

import 'package:intl/intl.dart';

class CurrencyFormatter {
  /// Formats amount as "TSh 15,000" (thousand separators, no decimals)
  static String format(num amount) {
    final formatter = NumberFormat('#,###', 'en_US');
    return 'TSh ${formatter.format(amount.round())}';
  }

  /// Parses string currency back to double if needed
  static double parse(String formattedString) {
    final cleaned = formattedString.replaceAll(RegExp(r'[^0-9.-]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }
}
