// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fintrack/app.dart';
import 'package:fintrack/features/auth/services/auth_service.dart';
import 'package:fintrack/features/expense/services/expense_service.dart';
import 'package:fintrack/features/income/services/income_service.dart';
import 'package:fintrack/features/savings/services/savings_service.dart';
import 'package:fintrack/features/budget/services/budget_service.dart';
import 'package:fintrack/features/wallet/services/wallet_service.dart';

void main() {
  testWidgets('FinTrack app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthService()),
          ChangeNotifierProvider(create: (_) => ExpenseService()),
          ChangeNotifierProvider(create: (_) => IncomeService()),
          ChangeNotifierProvider(create: (_) => SavingsService()),
          ChangeNotifierProvider(create: (_) => BudgetService()),
          ChangeNotifierProvider(create: (_) => WalletService()),
        ],
        child: const FinTrackApp(),
      ),
    );

    // Verify app starts and shows FinTrack wordmark
    expect(find.text('FinTrack'), findsOneWidget);
  });
}
