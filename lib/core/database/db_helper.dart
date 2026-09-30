// lib/core/database/db_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:fintrack/core/constants/db_constants.dart';
import 'package:fintrack/core/constants/app_constants.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();
  static Database? _database;

  DbHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(DbConstants.dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    const dbName = DbConstants.dbName;
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: DbConstants.dbVersion,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // 1. Wallets table
    await db.execute('''
      CREATE TABLE ${DbConstants.tableWallets} (
        ${DbConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbConstants.colWalletName} TEXT NOT NULL,
        ${DbConstants.colWalletType} TEXT NOT NULL,
        ${DbConstants.colWalletBalance} REAL NOT NULL DEFAULT 0.0,
        ${DbConstants.colWalletIcon} TEXT NOT NULL,
        ${DbConstants.colWalletColor} INTEGER NOT NULL
      )
    ''');

    // 2. Expenses table
    await db.execute('''
      CREATE TABLE ${DbConstants.tableExpenses} (
        ${DbConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbConstants.colExpenseTitle} TEXT NOT NULL,
        ${DbConstants.colExpenseAmount} REAL NOT NULL,
        ${DbConstants.colExpenseCategory} TEXT NOT NULL,
        ${DbConstants.colExpenseWalletId} INTEGER NOT NULL,
        ${DbConstants.colExpenseDate} TEXT NOT NULL,
        ${DbConstants.colExpenseNote} TEXT,
        FOREIGN KEY (${DbConstants.colExpenseWalletId}) REFERENCES ${DbConstants.tableWallets} (${DbConstants.colId}) ON DELETE CASCADE
      )
    ''');

    // 3. Income table
    await db.execute('''
      CREATE TABLE ${DbConstants.tableIncome} (
        ${DbConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbConstants.colIncomeTitle} TEXT NOT NULL,
        ${DbConstants.colIncomeAmount} REAL NOT NULL,
        ${DbConstants.colIncomeSource} TEXT NOT NULL,
        ${DbConstants.colIncomeWalletId} INTEGER NOT NULL,
        ${DbConstants.colIncomeDate} TEXT NOT NULL,
        ${DbConstants.colIncomeNote} TEXT,
        FOREIGN KEY (${DbConstants.colIncomeWalletId}) REFERENCES ${DbConstants.tableWallets} (${DbConstants.colId}) ON DELETE CASCADE
      )
    ''');

    // 4. Savings Goals table
    await db.execute('''
      CREATE TABLE ${DbConstants.tableSavingsGoals} (
        ${DbConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbConstants.colGoalTitle} TEXT NOT NULL,
        ${DbConstants.colGoalTargetAmount} REAL NOT NULL,
        ${DbConstants.colGoalCurrentAmount} REAL NOT NULL DEFAULT 0.0,
        ${DbConstants.colGoalTargetDate} TEXT NOT NULL,
        ${DbConstants.colGoalCategory} TEXT NOT NULL,
        ${DbConstants.colGoalIsCompleted} INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // 5. Budgets table
    await db.execute('''
      CREATE TABLE ${DbConstants.tableBudgets} (
        ${DbConstants.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DbConstants.colBudgetCategory} TEXT NOT NULL,
        ${DbConstants.colBudgetLimitAmount} REAL NOT NULL,
        ${DbConstants.colBudgetMonthYear} TEXT NOT NULL,
        UNIQUE(${DbConstants.colBudgetCategory}, ${DbConstants.colBudgetMonthYear})
      )
    ''');

    // Seed default wallets
    for (final wallet in AppConstants.defaultWallets) {
      await db.insert(DbConstants.tableWallets, {
        DbConstants.colWalletName: wallet['name'],
        DbConstants.colWalletType: wallet['type'],
        DbConstants.colWalletBalance: 0.0,
        DbConstants.colWalletIcon: wallet['icon'],
        DbConstants.colWalletColor: wallet['color'],
      });
    }
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Handle future database migrations here
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
