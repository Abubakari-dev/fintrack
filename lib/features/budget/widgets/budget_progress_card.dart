// lib/features/budget/widgets/budget_progress_card.dart

import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/core/widgets/progress_bar_widget.dart';
import 'package:fintrack/features/budget/services/budget_service.dart';
import 'package:fintrack/core/constants/app_constants.dart';

class BudgetProgressCard extends StatelessWidget {
  final BudgetProgress budgetProgress;
  final VoidCallback? onDelete;

  const BudgetProgressCard({
    super.key,
    required this.budgetProgress,
    this.onDelete,
  });

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'directions_car':
        return Icons.directions_car;
      case 'bolt':
        return Icons.bolt;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'medical_services':
        return Icons.medical_services;
      case 'movie':
        return Icons.movie;
      case 'school':
        return Icons.school;
      case 'home':
        return Icons.home;
      case 'people':
        return Icons.people;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final budget = budgetProgress.budget;
    final spent = budgetProgress.spent;
    final limit = budget.limitAmount;
    final progress = budgetProgress.percentage;

    final catData = AppConstants.expenseCategories.firstWhere(
      (c) => c['name'] == budget.category,
      orElse: () => {'icon': 'category', 'color': 0xFF6B6B6B},
    );
    final iconData = _getIconData(catData['icon'] as String);
    final colorVal = Color(catData['color'] as int);

    Color statusColor = AppColors.success;
    if (budgetProgress.isOverBudget) {
      statusColor = AppColors.expense;
    } else if (budgetProgress.isWarning) {
      statusColor = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorVal.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(iconData, color: colorVal, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  budget.category,
                  style: AppTextStyles.body(
                    context,
                    isDark: isDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 20,
                    color: AppColors.expense,
                  ),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spent: ${CurrencyFormatter.format(spent)}',
                style: AppTextStyles.caption(
                  context,
                  isDark: isDark,
                ).copyWith(color: statusColor, fontWeight: FontWeight.bold),
              ),
              Text(
                'Limit: ${CurrencyFormatter.format(limit)}',
                style: AppTextStyles.caption(context, isDark: isDark),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ProgressBarWidget(progress: progress, color: statusColor, height: 8),
        ],
      ),
    );
  }
}
