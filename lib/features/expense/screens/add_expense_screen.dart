// lib/features/expense/screens/add_expense_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fintrack/core/constants/app_constants.dart';
import 'package:fintrack/core/theme/app_colors.dart';
import 'package:fintrack/core/theme/app_text_styles.dart';
import 'package:fintrack/core/widgets/primary_button.dart';
import 'package:fintrack/features/expense/models/expense.dart';
import 'package:fintrack/features/expense/services/expense_service.dart';
import 'package:fintrack/features/wallet/services/wallet_service.dart';
import 'package:fintrack/features/wallet/widgets/wallet_selector.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _selectedCategory = AppConstants.expenseCategories.first['name'];
  int? _selectedWalletId;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final walletService = context.read<WalletService>();
      walletService.loadWallets().then((_) {
        if (walletService.wallets.isNotEmpty) {
          setState(() {
            _selectedWalletId = walletService.wallets.first.id;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedWalletId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a wallet')));
      return;
    }

    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    final title = _titleController.text.trim();
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

    final expense = Expense(
      title: title.isEmpty ? _selectedCategory : title,
      amount: amount,
      category: _selectedCategory,
      walletId: _selectedWalletId!,
      date: dateStr,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    final expenseService = context.read<ExpenseService>();
    final walletService = context.read<WalletService>();
    final nav = Navigator.of(context);

    await expenseService.addExpense(expense);
    if (!mounted) return;
    await walletService.loadWallets();
    if (!mounted) return;

    nav.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final walletService = context.watch<WalletService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount Input
                Text(
                  'Amount (TSh)',
                  style: AppTextStyles.body(
                    context,
                    isDark: isDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.largeAmount(context, isDark: isDark),
                  decoration: InputDecoration(
                    hintText: '0',
                    prefixText: 'TSh ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkSurface
                        : AppColors.lightSurface,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value.trim()) == null ||
                        double.parse(value.trim()) <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Title / Description
                Text(
                  'Title (Optional)',
                  style: AppTextStyles.body(
                    context,
                    isDark: isDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Lunch at cafeteria',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkSurface
                        : AppColors.lightSurface,
                  ),
                ),
                const SizedBox(height: 20),
                // Category Selector
                Text(
                  'Category',
                  style: AppTextStyles.body(
                    context,
                    isDark: isDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppConstants.expenseCategories.map((cat) {
                    final name = cat['name'] as String;
                    return ChoiceChip(
                      label: Text(name),
                      selected: _selectedCategory == name,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedCategory = name;
                          });
                        }
                      },
                      selectedColor: AppColors.primaryAccent,
                      labelStyle: TextStyle(
                        color: _selectedCategory == name
                            ? Colors.white
                            : (isDark
                                  ? AppColors.darkPrimaryText
                                  : AppColors.lightPrimaryText),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // Wallet Selector
                Text(
                  'Paid From Wallet',
                  style: AppTextStyles.body(
                    context,
                    isDark: isDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                WalletSelector(
                  wallets: walletService.wallets,
                  selectedWalletId: _selectedWalletId,
                  onWalletSelected: (id) {
                    setState(() {
                      _selectedWalletId = id;
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Date Picker
                Text(
                  'Date',
                  style: AppTextStyles.body(
                    context,
                    isDark: isDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('yyyy-MM-dd').format(_selectedDate),
                          style: AppTextStyles.body(context, isDark: isDark),
                        ),
                        const Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: AppColors.primaryAccent,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Optional Note
                Text(
                  'Note (Optional)',
                  style: AppTextStyles.body(
                    context,
                    isDark: isDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Add any extra details...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.darkSurface
                        : AppColors.lightSurface,
                  ),
                ),
                const SizedBox(height: 32),
                PrimaryButton(text: 'Save Expense', onPressed: _saveExpense),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
