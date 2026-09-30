// lib/features/savings/models/savings_goal.dart

import 'package:fintrack/core/constants/db_constants.dart';

class SavingsGoal {
  final int? id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final String targetDate;
  final String category;
  final bool isCompleted;

  SavingsGoal({
    this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.category,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      DbConstants.colId: id,
      DbConstants.colGoalTitle: title,
      DbConstants.colGoalTargetAmount: targetAmount,
      DbConstants.colGoalCurrentAmount: currentAmount,
      DbConstants.colGoalTargetDate: targetDate,
      DbConstants.colGoalCategory: category,
      DbConstants.colGoalIsCompleted: isCompleted ? 1 : 0,
    };
  }

  factory SavingsGoal.fromMap(Map<String, dynamic> map) {
    return SavingsGoal(
      id: map[DbConstants.colId] as int?,
      title: map[DbConstants.colGoalTitle] as String? ?? '',
      targetAmount: (map[DbConstants.colGoalTargetAmount] as num?)?.toDouble() ?? 0.0,
      currentAmount: (map[DbConstants.colGoalCurrentAmount] as num?)?.toDouble() ?? 0.0,
      targetDate: map[DbConstants.colGoalTargetDate] as String? ?? '',
      category: map[DbConstants.colGoalCategory] as String? ?? '',
      isCompleted: (map[DbConstants.colGoalIsCompleted] as int?) == 1,
    );
  }

  SavingsGoal copyWith({
    int? id,
    String? title,
    double? targetAmount,
    double? currentAmount,
    String? targetDate,
    String? category,
    bool? isCompleted,
  }) {
    return SavingsGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
