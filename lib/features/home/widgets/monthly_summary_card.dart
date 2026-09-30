// lib/features/home/widgets/monthly_summary_card.dart

import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';

class MonthlySummaryCard extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;

  const MonthlySummaryCard({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final netBalance = totalIncome - totalExpense;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0F766E), const Color(0xFF115E59)]
              : [const Color(0xFF0F766E), const Color(0xFF134E4A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This Month Balance',
            style: AppTextStyles.caption(
              context,
              isDark: true,
            ).copyWith(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            CurrencyFormatter.format(netBalance),
            style: AppTextStyles.largeAmount(
              context,
              isDark: true,
            ).copyWith(color: Colors.white, fontSize: 32),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_downward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Income',
                          style: AppTextStyles.caption(
                            context,
                            isDark: true,
                          ).copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.format(totalIncome),
                          style: AppTextStyles.body(
                            context,
                            isDark: true,
                            fontWeight: FontWeight.bold,
                          ).copyWith(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 36,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expense',
                          style: AppTextStyles.caption(
                            context,
                            isDark: true,
                          ).copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.format(totalExpense),
                          style: AppTextStyles.body(
                            context,
                            isDark: true,
                            fontWeight: FontWeight.bold,
                          ).copyWith(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
