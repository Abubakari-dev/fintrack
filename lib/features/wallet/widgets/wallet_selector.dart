// lib/features/wallet/widgets/wallet_selector.dart

import 'package:flutter/material.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/features/wallet/models/wallet.dart';

class WalletSelector extends StatelessWidget {
  final List<Wallet> wallets;
  final int? selectedWalletId;
  final ValueChanged<int> onWalletSelected;

  const WalletSelector({
    super.key,
    required this.wallets,
    required this.selectedWalletId,
    required this.onWalletSelected,
  });

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'payments':
        return Icons.payments;
      case 'phone_android':
        return Icons.phone_android;
      case 'account_balance':
        return Icons.account_balance;
      default:
        return Icons.wallet;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: wallets.length,
        itemBuilder: (context, index) {
          final wallet = wallets[index];
          final isSelected = wallet.id == selectedWalletId;
          final iconData = _getIconData(wallet.icon);
          final walletColor = Color(wallet.color);

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => onWalletSelected(wallet.id!),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? walletColor
                      : (isDark
                            ? AppColors.darkSurface
                            : AppColors.lightSurface),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? walletColor
                        : (isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      iconData,
                      size: 16,
                      color: isSelected ? Colors.white : walletColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      wallet.name,
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
            ),
          );
        },
      ),
    );
  }
}
