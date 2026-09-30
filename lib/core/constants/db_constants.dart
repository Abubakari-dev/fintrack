// lib/core/constants/db_constants.dart

class DbConstants {
  static const String dbName = 'fintrack.db';
  static const int dbVersion = 1;

  // Table names
  static const String tableExpenses = 'expenses';
  static const String tableIncome = 'income';
  static const String tableSavingsGoals = 'savings_goals';
  static const String tableBudgets = 'budgets';
  static const String tableWallets = 'wallets';

  // Common columns
  static const String colId = 'id';
  static const String colCreatedAt = 'created_at';

  // Expenses columns
  static const String colExpenseTitle = 'title';
  static const String colExpenseAmount = 'amount';
  static const String colExpenseCategory = 'category';
  static const String colExpenseWalletId = 'wallet_id';
  static const String colExpenseDate = 'date';
  static const String colExpenseNote = 'note';

  // Income columns
  static const String colIncomeTitle = 'title';
  static const String colIncomeAmount = 'amount';
  static const String colIncomeSource = 'source';
  static const String colIncomeWalletId = 'wallet_id';
  static const String colIncomeDate = 'date';
  static const String colIncomeNote = 'note';

  // Savings Goals columns
  static const String colGoalTitle = 'title';
  static const String colGoalTargetAmount = 'target_amount';
  static const String colGoalCurrentAmount = 'current_amount';
  static const String colGoalTargetDate = 'target_date';
  static const String colGoalCategory = 'category';
  static const String colGoalIsCompleted = 'is_completed';

  // Budgets columns
  static const String colBudgetCategory = 'category';
  static const String colBudgetLimitAmount = 'limit_amount';
  static const String colBudgetMonthYear = 'month_year'; // Format: "YYYY-MM"

  // Wallets columns
  static const String colWalletName = 'name';
  static const String colWalletType = 'type';
  static const String colWalletBalance = 'balance';
  static const String colWalletIcon = 'icon';
  static const String colWalletColor = 'color';
}
