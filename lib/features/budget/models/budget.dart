// lib/features/budget/models/budget.dart

import 'package:fintrack/core/constants/db_constants.dart';

class Budget {
  final int? id;
  final String category;
  final double limitAmount;
  final String monthYear; // YYYY-MM

  Budget({
    this.id,
    required this.category,
    required this.limitAmount,
    required this.monthYear,
  });

  Map<String, dynamic> toMap() {
    return {
      DbConstants.colId: id,
      DbConstants.colBudgetCategory: category,
      DbConstants.colBudgetLimitAmount: limitAmount,
      DbConstants.colBudgetMonthYear: monthYear,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map[DbConstants.colId] as int?,
      category: map[DbConstants.colBudgetCategory] as String? ?? '',
      limitAmount: (map[DbConstants.colBudgetLimitAmount] as num?)?.toDouble() ?? 0.0,
      monthYear: map[DbConstants.colBudgetMonthYear] as String? ?? '',
    );
  }

  Budget copyWith({
    int? id,
    String? category,
    double? limitAmount,
    String? monthYear,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      limitAmount: limitAmount ?? this.limitAmount,
      monthYear: monthYear ?? this.monthYear,
    );
  }
}
