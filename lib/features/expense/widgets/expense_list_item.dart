// lib/features/expense/widgets/expense_list_item.dart

import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/features/expense/models/expense.dart';
import 'package:fintrack/core/constants/app_constants.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onTap;

  const ExpenseListItem({super.key, required this.expense, this.onTap});

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

    final catData = AppConstants.expenseCategories.firstWhere(
      (c) => c['name'] == expense.category,
      orElse: () => {'icon': 'category', 'color': 0xFF6B6B6B},
    );
    final iconData = _getIconData(catData['icon'] as String);
    final colorVal = Color(catData['color'] as int);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorVal.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: colorVal, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: AppTextStyles.body(
                      context,
                      isDark: isDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${expense.category} • ${expense.date}',
                    style: AppTextStyles.caption(context, isDark: isDark),
                  ),
                  if (expense.note != null && expense.note!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      expense.note!,
                      style: AppTextStyles.caption(
                        context,
                        isDark: isDark,
                      ).copyWith(fontStyle: FontStyle.italic),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '-${CurrencyFormatter.format(expense.amount)}',
              style: AppTextStyles.body(
                context,
                isDark: isDark,
                fontWeight: FontWeight.bold,
              ).copyWith(color: AppColors.expense),
            ),
          ],
        ),
      ),
    );
  }
}
