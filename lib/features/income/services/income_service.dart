// lib/features/income/services/income_service.dart

import 'package:flutter/foundation.dart';
import 'package:fintrack/core/database/db_helper.dart';
import 'package:fintrack/core/constants/db_constants.dart';
import 'package:fintrack/features/income/models/income.dart';

class IncomeService extends ChangeNotifier {
  List<Income> _incomes = [];
  bool _isLoading = false;

  List<Income> get incomes => _incomes;
  bool get isLoading => _isLoading;

  Future<void> loadIncomes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = await DbHelper.instance.database;
      final maps = await db.query(DbConstants.tableIncome, orderBy: '${DbConstants.colIncomeDate} DESC, ${DbConstants.colId} DESC');
      _incomes = maps.map((map) => Income.fromMap(map)).toList();
    } catch (e) {
      debugPrint('Error loading income: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addIncome(Income income) async {
    final db = await DbHelper.instance.database;
    await db.insert(DbConstants.tableIncome, income.toMap());
    await loadIncomes();
  }

  Future<void> updateIncome(Income income) async {
    final db = await DbHelper.instance.database;
    await db.update(
      DbConstants.tableIncome,
      income.toMap(),
      where: '${DbConstants.colId} = ?',
      whereArgs: [income.id],
    );
    await loadIncomes();
  }

  Future<void> deleteIncome(int id) async {
    final db = await DbHelper.instance.database;
    await db.delete(
      DbConstants.tableIncome,
      where: '${DbConstants.colId} = ?',
      whereArgs: [id],
    );
    await loadIncomes();
  }

  /// Total income for a given month (format "YYYY-MM")
  double getTotalIncomeForMonth(String yearMonth) {
    return _incomes
        .where((i) => i.date.startsWith(yearMonth))
        .fold(0.0, (sum, i) => sum + i.amount);
  }

  /// Income by date range
  List<Income> getIncomeByDateRange(DateTime start, DateTime end) {
    return _incomes.where((i) {
      final date = DateTime.tryParse(i.date);
      if (date == null) return false;
      return date.isAfter(start.subtract(const Duration(days: 1))) &&
          date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }
}
