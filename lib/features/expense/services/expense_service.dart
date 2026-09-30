// lib/features/expense/services/expense_service.dart

import 'package:flutter/foundation.dart';
import 'package:fintrack/core/database/db_helper.dart';
import 'package:fintrack/core/constants/db_constants.dart';
import 'package:fintrack/features/expense/models/expense.dart';

class ExpenseService extends ChangeNotifier {
  List<Expense> _expenses = [];
  bool _isLoading = false;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;

  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = await DbHelper.instance.database;
      final maps = await db.query(DbConstants.tableExpenses, orderBy: '${DbConstants.colExpenseDate} DESC, ${DbConstants.colId} DESC');
      _expenses = maps.map((map) => Expense.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Error loading expenses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addExpense(Expense expense) async {
    final db = await DbHelper.instance.database;
    await db.insert(DbConstants.tableExpenses, expense.toMap());
    await loadExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await DbHelper.instance.database;
    await db.update(
      DbConstants.tableExpenses,
      expense.toMap(),
      where: '${DbConstants.colId} = ?',
      whereArgs: [expense.id],
    );
    await loadExpenses();
  }

  Future<void> deleteExpense(int id) async {
    final db = await DbHelper.instance.database;
    await db.delete(
      DbConstants.tableExpenses,
      where: '${DbConstants.colId} = ?',
      whereArgs: [id],
    );
    await loadExpenses();
  }

  /// Get recent expenses (last N)
  List<Expense> getRecentExpenses({int limit = 5}) {
    return _expenses.take(limit).toList();
  }

  /// Total spent for a given month (format "YYYY-MM")
  double getTotalSpentForMonth(String yearMonth) {
    return _expenses
        .where((e) => e.date.startsWith(yearMonth))
        .fold(0.0, (sum, e) => sum + e.amount);
  }

  /// Total spent per category for a given month (format "YYYY-MM")
  Map<String, double> getSpentPerCategoryForMonth(String yearMonth) {
    final Map<String, double> totals = {};
    final filtered = _expenses.where((e) => e.date.startsWith(yearMonth));
    for (final e in filtered) {
      totals[e.category] = (totals[e.category] ?? 0.0) + e.amount;
    }
    return totals;
  }

  /// Expenses by date range
  List<Expense> getExpensesByDateRange(DateTime start, DateTime end) {
    return _expenses.where((e) {
      final date = DateTime.tryParse(e.date);
      if (date == null) return false;
      return date.isAfter(start.subtract(const Duration(days: 1))) &&
          date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }
}
