// lib/features/expense/widgets/category_chip.dart

import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const CategoryChip({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chipColor = color ?? AppColors.primaryAccent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? chipColor
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? chipColor
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? Colors.white
                  : (isDark
                        ? AppColors.darkPrimaryText
                        : AppColors.lightPrimaryText),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style:
                  AppTextStyles.body(
                    context,
                    isDark: isDark,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ).copyWith(
                    color: isSelected
                        ? Colors.white
                        : (isDark
                              ? AppColors.darkPrimaryText
                              : AppColors.lightPrimaryText),
                    fontSize: 13,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
