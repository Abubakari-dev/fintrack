// lib/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:fintrack/core/constants/app_constants.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/widgets/bottom_nav_bar.dart';
import 'package:fintrack/features/home/widgets/monthly_summary_card.dart';
import 'package:fintrack/features/expense/services/expense_service.dart';
import 'package:fintrack/features/income/services/income_service.dart';
import 'package:fintrack/features/wallet/services/wallet_service.dart';
import 'package:fintrack/features/expense/widgets/expense_list_item.dart';
import 'package:fintrack/features/expense/widgets/category_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentIndex = 0;
  String? _selectedCategoryFilter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final expenseService = context.read<ExpenseService>();
    final incomeService = context.read<IncomeService>();
    final walletService = context.read<WalletService>();

    await expenseService.loadExpenses();
    if (!mounted) return;
    await incomeService.loadIncomes();
    if (!mounted) return;
    await walletService.loadWallets();
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/history');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/goals');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/insights');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final yearMonth = DateFormat('yyyy-MM').format(now);

    final expenseService = context.watch<ExpenseService>();
    final incomeService = context.watch<IncomeService>();

    final totalIncome = incomeService.getTotalIncomeForMonth(yearMonth);
    final totalExpense = expenseService.getTotalSpentForMonth(yearMonth);
    final spentPerCategory = expenseService.getSpentPerCategoryForMonth(
      yearMonth,
    );

    final recentExpenses = expenseService.getRecentExpenses(limit: 5);
    final filteredExpenses = _selectedCategoryFilter == null
        ? recentExpenses
        : recentExpenses
              .where((e) => e.category == _selectedCategoryFilter)
              .toList();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jambo! 👋',
                          style: AppTextStyles.caption(
                            context,
                            isDark: isDark,
                          ).copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppConstants.appName,
                          style: AppTextStyles.sectionTitle(
                            context,
                            isDark: isDark,
                          ).copyWith(fontSize: 22),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.account_balance_wallet_outlined),
                      onPressed: () => Navigator.pushNamed(context, '/wallets'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Monthly Summary Card
                MonthlySummaryCard(
                  totalIncome: totalIncome,
                  totalExpense: totalExpense,
                ),
                const SizedBox(height: 24),
                // Spending Breakdown Donut Chart
                if (spentPerCategory.isNotEmpty) ...[
                  Text(
                    'This Month Spending by Category',
                    style: AppTextStyles.sectionTitle(context, isDark: isDark),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                        width: 1,
                      ),
                    ),
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: spentPerCategory.entries.map((entry) {
                          final catName = entry.key;
                          final amount = entry.value;
                          final catData = AppConstants.expenseCategories
                              .firstWhere(
                                (c) => c['name'] == catName,
                                orElse: () => {'color': 0xFF6B6B6B},
                              );
                          final color = Color(catData['color'] as int);
                          return PieChartSectionData(
                            color: color,
                            value: amount,
                            title: '',
                            radius: 35,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                // Category Filter Chips
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CategoryChip(
                          label: 'All',
                          icon: Icons.all_inclusive,
                          isSelected: _selectedCategoryFilter == null,
                          onTap: () =>
                              setState(() => _selectedCategoryFilter = null),
                        ),
                      ),
                      ...AppConstants.expenseCategories.map((cat) {
                        final name = cat['name'] as String;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: CategoryChip(
                            label: name,
                            icon: Icons.category,
                            isSelected: _selectedCategoryFilter == name,
                            onTap: () => setState(
                              () => _selectedCategoryFilter = name,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Recent Expenses Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Expenses',
                      style: AppTextStyles.sectionTitle(
                        context,
                        isDark: isDark,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/history'),
                      child: Text(
                        'See All',
                        style: AppTextStyles.body(context, isDark: isDark)
                            .copyWith(
                              color: AppColors.primaryAccent,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Recent Expenses List
                if (expenseService.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (filteredExpenses.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Text(
                      'No expenses recorded yet.',
                      style: AppTextStyles.caption(context, isDark: isDark),
                    ),
                  )
                else
                  ...filteredExpenses.map(
                    (expense) => ExpenseListItem(expense: expense),
                  ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add_expense'),
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Expense'),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
