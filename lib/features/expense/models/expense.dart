// lib/features/expense/models/expense.dart

import 'package:fintrack/core/constants/db_constants.dart';

class Expense {
  final int? id;
  final String title;
  final double amount;
  final String category;
  final int walletId;
  final String date; // YYYY-MM-DD
  final String? note;
  final bool isRecurring;
  final String recurrence; // 'none', 'monthly', 'weekly'

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.walletId,
    required this.date,
    this.note,
    this.isRecurring = false,
    this.recurrence = 'none',
  });

  Map<String, dynamic> toMap() {
    return {
      DbConstants.colId: id,
      DbConstants.colExpenseTitle: title,
      DbConstants.colExpenseAmount: amount,
      DbConstants.colExpenseCategory: category,
      DbConstants.colExpenseWalletId: walletId,
      DbConstants.colExpenseDate: date,
      DbConstants.colExpenseNote: note,
      DbConstants.colExpenseIsRecurring: isRecurring ? 1 : 0,
      DbConstants.colExpenseRecurrence: recurrence,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map[DbConstants.colId] as int?,
      title: map[DbConstants.colExpenseTitle] as String? ?? '',
      amount: (map[DbConstants.colExpenseAmount] as num?)?.toDouble() ?? 0.0,
      category: map[DbConstants.colExpenseCategory] as String? ?? '',
      walletId: map[DbConstants.colExpenseWalletId] as int? ?? 1,
      date: map[DbConstants.colExpenseDate] as String? ?? '',
      note: map[DbConstants.colExpenseNote] as String?,
      isRecurring: (map[DbConstants.colExpenseIsRecurring] as int?) == 1,
      recurrence: map[DbConstants.colExpenseRecurrence] as String? ?? 'none',
    );
  }

  Expense copyWith({
    int? id,
    String? title,
    double? amount,
    String? category,
    int? walletId,
    String? date,
    String? note,
    bool? isRecurring,
    String? recurrence,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      walletId: walletId ?? this.walletId,
      date: date ?? this.date,
      note: note ?? this.note,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrence: recurrence ?? this.recurrence,
    );
  }
}
