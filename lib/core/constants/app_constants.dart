// lib/core/constants/app_constants.dart

class AppConstants {
  static const String appName = 'FinTrack';
  static const String appTagline = 'Track your money. Reach your goals.';
  static const String appVersion = '1.0.0';

  // Expense Categories with default color values and icons
  static const List<Map<String, dynamic>> expenseCategories = [
    {'name': 'Food & Dining', 'icon': 'restaurant', 'color': 0xFFDC2626},
    {'name': 'Transport', 'icon': 'directions_car', 'color': 0xFF2563EB},
    {'name': 'Utilities', 'icon': 'bolt', 'color': 0xFFD97706},
    {'name': 'Shopping', 'icon': 'shopping_bag', 'color': 0xFF7C3AED},
    {'name': 'Health', 'icon': 'medical_services', 'color': 0xFF059669},
    {'name': 'Entertainment', 'icon': 'movie', 'color': 0xFFDB2777},
    {'name': 'Education', 'icon': 'school', 'color': 0xFF4F46E5},
    {'name': 'Rent & Housing', 'icon': 'home', 'color': 0xFF0891B2},
    {'name': 'Family & Friends', 'icon': 'people', 'color': 0xFFEA580C},
    {'name': 'Other', 'icon': 'category', 'color': 0xFF6B6B6B},
  ];

  // Income Sources
  static const List<String> incomeSources = [
    'Salary',
    'Business',
    'Freelance / Side Hustle',
    'Investment / Dividends',
    'Family Support / Gift',
    'Other',
  ];

  // Default Wallets
  static const List<Map<String, dynamic>> defaultWallets = [
    {'name': 'Cash', 'type': 'cash', 'icon': 'payments', 'color': 0xFF16A34A},
    {
      'name': 'M-Pesa',
      'type': 'mobile',
      'icon': 'phone_android',
      'color': 0xFFDC2626,
    },
    {
      'name': 'Tigo Pesa',
      'type': 'mobile',
      'icon': 'phone_android',
      'color': 0xFF2563EB,
    },
    {
      'name': 'Airtel Money',
      'type': 'mobile',
      'icon': 'phone_android',
      'color': 0xFFEA580C,
    },
    {
      'name': 'Bank Account',
      'type': 'bank',
      'icon': 'account_balance',
      'color': 0xFF0F766E,
    },
  ];
}
