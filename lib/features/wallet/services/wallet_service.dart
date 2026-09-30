// lib/features/wallet/services/wallet_service.dart

import 'package:flutter/foundation.dart';
import 'package:fintrack/core/database/db_helper.dart';
import 'package:fintrack/core/constants/db_constants.dart';
import 'package:fintrack/features/wallet/models/wallet.dart';

class WalletService extends ChangeNotifier {
  List<Wallet> _wallets = [];
  bool _isLoading = false;

  List<Wallet> get wallets => _wallets;
  bool get isLoading => _isLoading;

  Future<void> loadWallets() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = await DbHelper.instance.database;
      final maps = await db.query(DbConstants.tableWallets, orderBy: '${DbConstants.colId} ASC');

      List<Wallet> loadedWallets = [];
      for (final map in maps) {
        final wallet = Wallet.fromMap(map);
        final walletId = wallet.id!;

        // Sum income for wallet
        final incomeResult = await db.rawQuery(
          'SELECT SUM(${DbConstants.colIncomeAmount}) as total FROM ${DbConstants.tableIncome} WHERE ${DbConstants.colIncomeWalletId} = ?',
          [walletId],
        );
        final totalIncome = (incomeResult.first['total'] as num?)?.toDouble() ?? 0.0;

        // Sum expense for wallet
        final expenseResult = await db.rawQuery(
          'SELECT SUM(${DbConstants.colExpenseAmount}) as total FROM ${DbConstants.tableExpenses} WHERE ${DbConstants.colExpenseWalletId} = ?',
          [walletId],
        );
        final totalExpense = (expenseResult.first['total'] as num?)?.toDouble() ?? 0.0;

        final calculatedBalance = totalIncome - totalExpense;
        loadedWallets.add(wallet.copyWith(balance: calculatedBalance));
      }

      _wallets = loadedWallets;
    } catch (e) {
      debugPrint('Error loading wallets: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addWallet(Wallet wallet) async {
    final db = await DbHelper.instance.database;
    await db.insert(DbConstants.tableWallets, wallet.toMap());
    await loadWallets();
  }

  Future<void> updateWallet(Wallet wallet) async {
    final db = await DbHelper.instance.database;
    await db.update(
      DbConstants.tableWallets,
      wallet.toMap(),
      where: '${DbConstants.colId} = ?',
      whereArgs: [wallet.id],
    );
    await loadWallets();
  }

  Future<void> deleteWallet(int id) async {
    final db = await DbHelper.instance.database;
    await db.delete(
      DbConstants.tableWallets,
      where: '${DbConstants.colId} = ?',
      whereArgs: [id],
    );
    await loadWallets();
  }

  double get totalNetWorth {
    return _wallets.fold(0.0, (sum, w) => sum + w.balance);
  }
}
