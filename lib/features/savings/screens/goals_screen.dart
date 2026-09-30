// lib/features/savings/screens/goals_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/core/widgets/bottom_nav_bar.dart';
import 'package:fintrack/core/widgets/progress_bar_widget.dart';
import 'package:fintrack/features/savings/models/savings_goal.dart';
import 'package:fintrack/features/savings/services/savings_service.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SavingsService>().loadGoals();
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
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/insights');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  void _showAddGoalDialog() {
    final titleController = TextEditingController();
    final targetController = TextEditingController();
    final dateController = TextEditingController(text: '2025-12-31');
    String selectedCategory = 'Emergency Fund';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Savings Goal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Goal Title (e.g., New Laptop)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Target Amount (TSh)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    labelText: 'Target Date (YYYY-MM-DD)',
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
                final title = titleController.text.trim();
                final target =
                    double.tryParse(targetController.text.trim()) ?? 0.0;
                if (title.isNotEmpty && target > 0) {
                  final goal = SavingsGoal(
                    title: title,
                    targetAmount: target,
                    currentAmount: 0.0,
                    targetDate: dateController.text.trim(),
                    category: selectedCategory,
                    isCompleted: false,
                  );
                  await context.read<SavingsService>().addGoal(goal);
                  if (!mounted) return;
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddContributionDialog(SavingsGoal goal) {
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Contribute to ${goal.title}'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount (TSh)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final amount =
                    double.tryParse(amountController.text.trim()) ?? 0.0;
                if (amount > 0) {
                  await context.read<SavingsService>().addContribution(
                    goal.id!,
                    amount,
                  );
                  if (!mounted) return;
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                }
              },
              child: const Text('Contribute'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final savingsService = context.watch<SavingsService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Goals'),
        automaticallyImplyLeading: false,
      ),
      body: savingsService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : savingsService.goals.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.flag_outlined,
                    size: 64,
                    color: isDark
                        ? AppColors.darkSecondaryText
                        : AppColors.lightSecondaryText,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No savings goals yet.',
                    style: AppTextStyles.caption(context, isDark: isDark),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: savingsService.goals.length,
              itemBuilder: (context, index) {
                final goal = savingsService.goals[index];
                final progress = savingsService.getGoalProgress(goal);

                return Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            goal.title,
                            style: AppTextStyles.body(
                              context,
                              isDark: isDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: AppColors.expense,
                            ),
                            onPressed: () => context
                                .read<SavingsService>()
                                .deleteGoal(goal.id!),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Target Date: ${goal.targetDate}',
                        style: AppTextStyles.caption(context, isDark: isDark),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            CurrencyFormatter.format(goal.currentAmount),
                            style: AppTextStyles.body(
                              context,
                              isDark: isDark,
                              fontWeight: FontWeight.bold,
                            ).copyWith(color: AppColors.success),
                          ),
                          Text(
                            'Goal: ${CurrencyFormatter.format(goal.targetAmount)}',
                            style: AppTextStyles.caption(
                              context,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ProgressBarWidget(
                        progress: progress,
                        color: goal.isCompleted
                            ? AppColors.success
                            : AppColors.primaryAccent,
                        height: 10,
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: OutlinedButton.icon(
                          onPressed: () => _showAddContributionDialog(goal),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add Funds'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryAccent,
                            side: const BorderSide(
                              color: AppColors.primaryAccent,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddGoalDialog,
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Goal'),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
