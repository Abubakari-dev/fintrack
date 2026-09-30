// lib/core/widgets/progress_bar_widget.dart

import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';

class ProgressBarWidget extends StatelessWidget {
  final double progress; // 0.0 to 1.0+
  final Color? color;
  final double height;

  const ProgressBarWidget({
    super.key,
    required this.progress,
    this.color,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final barColor =
        color ??
        (progress > 1.0
            ? AppColors.expense
            : progress >= 0.8
            ? AppColors.warning
            : AppColors.success);

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LinearProgressIndicator(
        value: clampedProgress,
        backgroundColor: AppColors.lightBorder,
        valueColor: AlwaysStoppedAnimation<Color>(barColor),
        minHeight: height,
      ),
    );
  }
}
