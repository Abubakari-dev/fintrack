// lib/features/wallet/screens/wallet_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/utils/currency_formatter.dart';
import 'package:fintrack/features/wallet/models/wallet.dart';
import 'package:fintrack/features/wallet/services/wallet_service.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletService>().loadWallets();
    });
  }

  void _showAddWalletDialog() {
    final nameController = TextEditingController();
    String type = 'mobile';
    String icon = 'phone_android';
    int color = 0xFFDC2626;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Add Wallet'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Wallet Name (e.g., Halotel Pesa)',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  final wallet = Wallet(
                    name: name,
                    type: type,
                    balance: 0.0,
                    icon: icon,
                    color: color,
                  );
                  await context.read<WalletService>().addWallet(wallet);
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final walletService = context.watch<WalletService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Wallets & Accounts')),
      body: walletService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Total Net Worth Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Net Worth',
                        style: AppTextStyles.caption(
                          context,
                          isDark: true,
                        ).copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        CurrencyFormatter.format(walletService.totalNetWorth),
                        style: AppTextStyles.largeAmount(
                          context,
                          isDark: true,
                        ).copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'All Wallets',
                  style: AppTextStyles.sectionTitle(context, isDark: isDark),
                ),
                const SizedBox(height: 12),
                ...walletService.wallets.map((wallet) {
                  final walletColor = Color(wallet.color);
                  return Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 12),
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
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: walletColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.account_balance_wallet,
                            color: walletColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                wallet.name,
                                style: AppTextStyles.body(
                                  context,
                                  isDark: isDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                wallet.type.toUpperCase(),
                                style: AppTextStyles.caption(
                                  context,
                                  isDark: isDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(wallet.balance),
                          style:
                              AppTextStyles.body(
                                context,
                                isDark: isDark,
                                fontWeight: FontWeight.bold,
                              ).copyWith(
                                color: wallet.balance >= 0
                                    ? AppColors.success
                                    : AppColors.expense,
                              ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddWalletDialog,
        backgroundColor: AppColors.primaryAccent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Wallet'),
      ),
    );
  }
}
