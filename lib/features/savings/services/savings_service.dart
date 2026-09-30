// lib/features/savings/services/savings_service.dart

import 'package:flutter/foundation.dart';
import 'package:fintrack/core/database/db_helper.dart';
import 'package:fintrack/core/constants/db_constants.dart';
import 'package:fintrack/features/savings/models/savings_goal.dart';

class SavingsService extends ChangeNotifier {
  List<SavingsGoal> _goals = [];
  bool _isLoading = false;

  List<SavingsGoal> get goals => _goals;
  bool get isLoading => _isLoading;

  Future<void> loadGoals() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = await DbHelper.instance.database;
      final maps = await db.query(DbConstants.tableSavingsGoals, orderBy: '${DbConstants.colId} DESC');
      _goals = maps.map((map) => SavingsGoal.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Error loading savings goals: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addGoal(SavingsGoal goal) async {
    final db = await DbHelper.instance.database;
    await db.insert(DbConstants.tableSavingsGoals, goal.toMap());
    await loadGoals();
  }

  Future<void> updateGoal(SavingsGoal goal) async {
    final db = await DbHelper.instance.database;
    await db.update(
      DbConstants.tableSavingsGoals,
      goal.toMap(),
      where: '${DbConstants.colId} = ?',
      whereArgs: [goal.id],
    );
    await loadGoals();
  }

  Future<void> deleteGoal(int id) async {
    final db = await DbHelper.instance.database;
    await db.delete(
      DbConstants.tableSavingsGoals,
      where: '${DbConstants.colId} = ?',
      whereArgs: [id],
    );
    await loadGoals();
  }

  /// Add contribution to goal and check if completed
  Future<void> addContribution(int goalId, double amount) async {
    final index = _goals.indexWhere((g) => g.id == goalId);
    if (index != -1) {
      final goal = _goals[index];
      final newCurrent = goal.currentAmount + amount;
      final isCompleted = newCurrent >= goal.targetAmount;
      final updated = goal.copyWith(
        currentAmount: newCurrent,
        isCompleted: isCompleted,
      );
      await updateGoal(updated);
    }
  }

  /// Calculate progress percentage (0.0 to 1.0+)
  double getGoalProgress(SavingsGoal goal) {
    if (goal.targetAmount <= 0) return 0.0;
    return (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0);
  }
}
