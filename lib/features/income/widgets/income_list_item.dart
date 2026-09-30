// lib/features/income/widgets/income_list_item.dart

import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/features/income/models/income.dart';

class IncomeListItem extends StatelessWidget {
  final Income income;
  final VoidCallback? onTap;

  const IncomeListItem({super.key, required this.income, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_downward,
                color: AppColors.success,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    income.title,
                    style: AppTextStyles.body(
                      context,
                      isDark: isDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${income.source} • ${income.date}',
                    style: AppTextStyles.caption(context, isDark: isDark),
                  ),
                  if (income.note != null && income.note!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      income.note!,
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
              '+${CurrencyFormatter.format(income.amount)}',
              style: AppTextStyles.body(
                context,
                isDark: isDark,
                fontWeight: FontWeight.bold,
              ).copyWith(color: AppColors.success),
            ),
          ],
        ),
      ),
    );
  }
}
