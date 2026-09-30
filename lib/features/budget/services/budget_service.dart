// lib/features/budget/services/budget_service.dart

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fintrack/core/database/db_helper.dart';
import 'package:fintrack/core/constants/db_constants.dart';
import 'package:fintrack/features/budget/models/budget.dart';
import 'package:fintrack/features/expense/services/expense_service.dart';

class BudgetProgress {
  final Budget budget;
  final double spent;

  BudgetProgress({required this.budget, required this.spent});

  double get percentage => budget.limitAmount > 0 ? (spent / budget.limitAmount) : 0.0;
  bool get isOverBudget => spent > budget.limitAmount;
  bool get isWarning => percentage >= 0.8 && !isOverBudget;
}

class BudgetService extends ChangeNotifier {
  List<Budget> _budgets = [];
  bool _isLoading = false;

  List<Budget> get budgets => _budgets;
  bool get isLoading => _isLoading;

  Future<void> loadBudgets(String yearMonth) async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = await DbHelper.instance.database;
      final maps = await db.query(
        DbConstants.tableBudgets,
        where: '${DbConstants.colBudgetMonthYear} = ?',
        whereArgs: [yearMonth],
      );
      _budgets = maps.map((map) => Budget.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Error loading budgets: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setBudget(Budget budget) async {
    final db = await DbHelper.instance.database;
    await db.insert(
      DbConstants.tableBudgets,
      budget.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await loadBudgets(budget.monthYear);
  }

  Future<void> deleteBudget(int id, String yearMonth) async {
    final db = await DbHelper.instance.database;
    await db.delete(
      DbConstants.tableBudgets,
      where: '${DbConstants.colId} = ?',
      whereArgs: [id],
    );
    await loadBudgets(yearMonth);
  }

  /// Get budget progress list for a given month by joining budgets with actual spending from ExpenseService
  List<BudgetProgress> getBudgetProgressList(String yearMonth, ExpenseService expenseService) {
    final spentPerCategory = expenseService.getSpentPerCategoryForMonth(yearMonth);
    return _budgets.map((budget) {
      final spent = spentPerCategory[budget.category] ?? 0.0;
      return BudgetProgress(budget: budget, spent: spent);
    }).toList();
  }
}
