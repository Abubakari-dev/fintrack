// lib/features/budget/screens/budget_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fintrack/core/constants/app_constants.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/features/budget/models/budget.dart';
import 'package:fintrack/features/budget/services/budget_service.dart';
import 'package:fintrack/features/budget/widgets/budget_progress_card.dart';
import 'package:fintrack/features/expense/services/expense_service.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  late String _currentYearMonth;

  @override
  void initState() {
    super.initState();
    _currentYearMonth = DateFormat('yyyy-MM').format(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseService>().loadExpenses();
      context.read<BudgetService>().loadBudgets(_currentYearMonth);
    });
  }

  void _showSetBudgetDialog() {
    String selectedCategory = AppConstants.expenseCategories.first['name'];
    final limitController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Set Category Budget'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  isExpanded: true,
                  items: AppConstants.expenseCategories.map((c) {
                    return DropdownMenuItem<String>(
                      value: c['name'] as String,
                      child: Text(c['name'] as String),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) selectedCategory = val;
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: limitController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monthly Limit (TSh)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final limit =
                    double.tryParse(limitController.text.trim()) ?? 0.0;
                if (limit > 0) {
                  final budget = Budget(
                    category: selectedCategory,
                    limitAmount: limit,
                    monthYear: _currentYearMonth,
                  );
                  await context.read<BudgetService>().setBudget(budget);
                  if (!mounted) return;
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final budgetService = context.watch<BudgetService>();
    final expenseService = context.watch<ExpenseService>();

    final budgetProgressList = budgetService.getBudgetProgressList(
      _currentYearMonth,
      expenseService,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Monthly Budgets ($_currentYearMonth)')),
      body: budgetService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : budgetProgressList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pie_chart_outline,
                    size: 64,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No budgets set for this month.',
                    style: AppTextStyles.caption(context, isDark: isDark),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: budgetProgressList.length,
              itemBuilder: (context, index) {
                final bp = budgetProgressList[index];
                return BudgetProgressCard(
                  budgetProgress: bp,
                  onDelete: () => context.read<BudgetService>().deleteBudget(
                    bp.budget.id!,
                    _currentYearMonth,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showSetBudgetDialog,
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Set Budget'),
      ),
    );
  }
}
