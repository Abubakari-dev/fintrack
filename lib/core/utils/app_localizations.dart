// lib/core/utils/app_localizations.dart

class AppLocalizations {
  final String locale;

  AppLocalizations(this.locale);

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'FinTrack',
      'tagline': 'Track your money. Reach your goals.',
      'home': 'Home',
      'history': 'History',
      'goals': 'Goals',
      'insights': 'Insights',
      'settings': 'Settings',
      'thisMonthBalance': 'This Month Balance',
      'income': 'Income',
      'expense': 'Expense',
      'recentExpenses': 'Recent Expenses',
      'seeAll': 'See All',
      'addExpense': 'Add Expense',
      'addIncome': 'Add Income',
      'savingsGoals': 'Savings Goals',
      'monthlyBudgets': 'Monthly Budgets',
      'walletsAccounts': 'Wallets & Accounts',
      'financialInsights': 'Financial Insights',
      'darkMode': 'Dark Mode',
      'securityPin': 'Security PIN',
      'clearData': 'Clear All Data',
      'language': 'Language',
      'swahili': 'Kiswahili',
      'english': 'English',
    },
    'sw': {
      'appTitle': 'FinTrack',
      'tagline': 'Fuatilia fedha zako. Fikia malengo yako.',
      'home': 'Nyumbani',
      'history': 'Historia',
      'goals': 'Malengo',
      'insights': 'Uchambuzi',
      'settings': 'Mipangilio',
      'thisMonthBalance': 'Salio la Mwezi Huu',
      'income': 'Mapato',
      'expense': 'Matumizi',
      'recentExpenses': 'Matumizi ya Hivi Karibuni',
      'seeAll': 'Ona Zote',
      'addExpense': 'Weka Matumizi',
      'addIncome': 'Weka Mapato',
      'savingsGoals': 'Malengo ya Kuweka Akiba',
      'monthlyBudgets': 'Bajeti za Mwezi',
      'walletsAccounts': 'Pochi na Akaunti',
      'financialInsights': 'Uchambuzi wa Kifedha',
      'darkMode': 'Hali ya Giza',
      'securityPin': 'Namba ya Siri (PIN)',
      'clearData': 'Futa Data Zote',
      'language': 'Lugha',
      'swahili': 'Kiswahili',
      'english': 'English',
    },
  };

  String translate(String key) {
    return _localizedValues[locale]?[key] ?? _localizedValues['en']?[key] ?? key;
  }
}
