// lib/features/income/models/income.dart

import 'package:fintrack/core/constants/db_constants.dart';

class Income {
  final int? id;
  final String title;
  final double amount;
  final String source;
  final int walletId;
  final String date; // YYYY-MM-DD
  final String? note;
  final bool isRecurring;
  final String recurrence; // 'none', 'monthly', 'weekly'

  Income({
    this.id,
    required this.title,
    required this.amount,
    required this.source,
    required this.walletId,
    required this.date,
    this.note,
    this.isRecurring = false,
    this.recurrence = 'none',
  });

  Map<String, dynamic> toMap() {
    return {
      DbConstants.colId: id,
      DbConstants.colIncomeTitle: title,
      DbConstants.colIncomeAmount: amount,
      DbConstants.colIncomeSource: source,
      DbConstants.colIncomeWalletId: walletId,
      DbConstants.colIncomeDate: date,
      DbConstants.colIncomeNote: note,
      DbConstants.colIncomeIsRecurring: isRecurring ? 1 : 0,
      DbConstants.colIncomeRecurrence: recurrence,
    };
  }

  factory Income.fromMap(Map<String, dynamic> map) {
    return Income(
      id: map[DbConstants.colId] as int?,
      title: map[DbConstants.colIncomeTitle] as String? ?? '',
      amount: (map[DbConstants.colIncomeAmount] as num?)?.toDouble() ?? 0.0,
      source: map[DbConstants.colIncomeSource] as String? ?? '',
      walletId: map[DbConstants.colIncomeWalletId] as int? ?? 1,
      date: map[DbConstants.colIncomeDate] as String? ?? '',
      note: map[DbConstants.colIncomeNote] as String?,
      isRecurring: (map[DbConstants.colIncomeIsRecurring] as int?) == 1,
      recurrence: map[DbConstants.colIncomeRecurrence] as String? ?? 'none',
    );
  }

  Income copyWith({
    int? id,
    String? title,
    double? amount,
    String? source,
    int? walletId,
    String? date,
    String? note,
    bool? isRecurring,
    String? recurrence,
  }) {
    return Income(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      source: source ?? this.source,
      walletId: walletId ?? this.walletId,
      date: date ?? this.date,
      note: note ?? this.note,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrence: recurrence ?? this.recurrence,
    );
  }
}
