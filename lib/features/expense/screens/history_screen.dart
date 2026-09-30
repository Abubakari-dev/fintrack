// lib/features/expense/screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/widgets/bottom_nav_bar.dart';
import 'package:fintrack/features/expense/services/expense_service.dart';
import 'package:fintrack/features/income/services/income_service.dart';
import 'package:fintrack/features/expense/widgets/expense_list_item.dart';
import 'package:fintrack/features/income/widgets/income_list_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  final int _currentIndex = 1;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseService>().loadExpenses();
      context.read<IncomeService>().loadIncomes();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
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
    final expenseService = context.watch<ExpenseService>();
    final incomeService = context.watch<IncomeService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryAccent,
          unselectedLabelColor: isDark
              ? AppColors.darkSecondaryText
              : AppColors.lightSecondaryText,
          indicatorColor: AppColors.primaryAccent,
          tabs: const [
            Tab(text: 'Expenses'),
            Tab(text: 'Income'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Expenses Tab
          expenseService.isLoading
              ? const Center(child: CircularProgressIndicator())
              : expenseService.expenses.isEmpty
              ? Center(
                  child: Text(
                    'No expenses recorded yet.',
                    style: AppTextStyles.caption(context, isDark: isDark),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: expenseService.expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenseService.expenses[index];
                    return Dismissible(
                      key: Key('expense_${expense.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: AppColors.expense,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        context.read<ExpenseService>().deleteExpense(
                          expense.id!,
                        );
                      },
                      child: ExpenseListItem(expense: expense),
                    );
                  },
                ),
          // Income Tab
          incomeService.isLoading
              ? const Center(child: CircularProgressIndicator())
              : incomeService.incomes.isEmpty
              ? Center(
                  child: Text(
                    'No income recorded yet.',
                    style: AppTextStyles.caption(context, isDark: isDark),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: incomeService.incomes.length,
                  itemBuilder: (context, index) {
                    final income = incomeService.incomes[index];
                    return Dismissible(
                      key: Key('income_${income.id}'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: AppColors.expense,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        context.read<IncomeService>().deleteIncome(income.id!);
                      },
                      child: IncomeListItem(income: income),
                    );
                  },
                ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
