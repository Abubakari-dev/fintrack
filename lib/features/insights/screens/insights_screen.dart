// lib/features/insights/screens/insights_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/core/widgets/bottom_nav_bar.dart';
import 'package:fintrack/features/expense/services/expense_service.dart';
import 'package:fintrack/features/income/services/income_service.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseService>().loadExpenses();
      context.read<IncomeService>().loadIncomes();
    });
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/history');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/goals');
        break;
      case 3:
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
    final currentYearMonth = DateFormat('yyyy-MM').format(now);

    // Last month calculation
    final lastMonthDate = DateTime(now.year, now.month - 1, 1);
    final lastYearMonth = DateFormat('yyyy-MM').format(lastMonthDate);

    final expenseService = context.watch<ExpenseService>();
    final incomeService = context.watch<IncomeService>();

    final currentSpent = expenseService.getTotalSpentForMonth(currentYearMonth);
    final lastSpent = expenseService.getTotalSpentForMonth(lastYearMonth);
    // currentIncome not needed in insights comparison, removed to avoid unused variable warning

    final spentPerCategory = expenseService.getSpentPerCategoryForMonth(
      currentYearMonth,
    );
    final sortedCategories = spentPerCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Insights'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Comparison Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly Spending Comparison',
                    style: AppTextStyles.sectionTitle(context, isDark: isDark),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'This Month',
                            style: AppTextStyles.caption(
                              context,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            CurrencyFormatter.format(currentSpent),
                            style: AppTextStyles.body(
                              context,
                              isDark: isDark,
                              fontWeight: FontWeight.bold,
                            ).copyWith(color: AppColors.expense),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Last Month',
                            style: AppTextStyles.caption(
                              context,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            CurrencyFormatter.format(lastSpent),
                            style: AppTextStyles.body(
                              context,
                              isDark: isDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Top Spending Categories',
              style: AppTextStyles.sectionTitle(context, isDark: isDark),
            ),
            const SizedBox(height: 12),
            if (sortedCategories.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                child: Text(
                  'No spending data for insights.',
                  style: AppTextStyles.caption(context, isDark: isDark),
                ),
              )
            else
              ...sortedCategories.map((entry) {
                final cat = entry.key;
                final amount = entry.value;
                final percentage = currentSpent > 0
                    ? (amount / currentSpent) * 100
                    : 0.0;

                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 12),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cat,
                            style: AppTextStyles.body(
                              context,
                              isDark: isDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${percentage.toStringAsFixed(1)}% of total monthly spending',
                            style: AppTextStyles.caption(
                              context,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        CurrencyFormatter.format(amount),
                        style: AppTextStyles.body(
                          context,
                          isDark: isDark,
                          fontWeight: FontWeight.bold,
                        ).copyWith(color: AppColors.expense),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
