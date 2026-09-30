# FinTrack — Personal Finance & Budget Tracker for Young Tanzanians

> "Track your money. Reach your goals."

**FinTrack** is a modern, feature-rich personal finance and budget-tracking mobile application built with **Flutter**. Designed specifically for young Tanzanians, FinTrack empowers users to manage multiple payment methods (Cash, M-Pesa, Tigo Pesa, Airtel Money, Bank Accounts), track daily expenses and income, set category budgets, save toward financial goals, and gain actionable financial insights.

---

## Key Features

- **Multi-Wallet Support:** Manage Cash, Mobile Money (*M-Pesa, Tigo Pesa, Airtel Money*), and Bank Accounts with real-time balance calculations.
- **Expense & Income Tracking:** Categorize daily spending and earnings with Tanzanian Shilling (`TSh`) formatting.
- **Smart Monthly Budgets:** Set spending limits per category and monitor budget health with visual progress bars and color-coded status alerts (Safe, Warning, Over-Budget).
- **Savings Goals:** Set target amounts and dates, track progress visually, and add contributions toward emergency funds, business capital, or school fees.
- **Visual Insights:** Interactive charts powered by `fl_chart` showing spending breakdowns by category and month-over-month comparisons.
- **Secure PIN Authentication:** Protect sensitive financial records with a 4-digit secure PIN (hashed using SHA-256 via `crypto`).
- **Dark & Light Mode:** Seamlessly switch between themes based on system preferences or settings.
- **Offline-First SQLite Storage:** Fast and reliable local data persistence using `sqflite`.

---

## Tech Stack & Architecture

- **Framework:** Flutter (Dart)
- **State Management:** Provider (`ChangeNotifier`)
- **Database:** SQLite (`sqflite` + `sqflite_common_ffi` for desktop support)
- **Charts:** `fl_chart`
- **Currency & Date Formatting:** `intl`
- **Security & Storage:** `shared_preferences` & `crypto` (SHA-256 PIN hashing)
- **Typography:** Google Fonts (`Inter`)

### Feature-First Folder Structure
```text
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/          # App & Database constants
│   ├── database/           # SQLite Singleton helper
│   ├── routes/             # Named routes & onGenerateRoute
│   ├── theme/              # Light & Dark ThemeData, AppColors, AppTextStyles
│   ├── utils/              # CurrencyFormatter (TSh)
│   └── widgets/            # Shared generic widgets
└── features/
    ├── auth/               # Onboarding, Login, PIN input, AuthService
    ├── budget/             # Budget models, screens, services, progress cards
    ├── expense/            # Expense models, add expense, history, services
    ├── home/               # Splash screen, home dashboard, summary card
    ├── income/             # Income models, add income, services
    ├── insights/           # Financial insights & comparisons screen
    ├── savings/            # Savings goals models, screens, services
    ├── settings/           # Settings screen (Theme, PIN, Data Wipe)
    └── wallet/             # Wallet models, screen, services, selectors
```

---

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (^3.13.3 or higher)
- Android Studio / VS Code with Flutter & Dart plugins installed.

### Installation & Running

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/fintrack.git
   cd fintrack
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   - **For Mobile (Android/iOS Emulator):**
     ```bash
     flutter run
     ```
   - **For Desktop (Windows/macOS/Linux):**
     ```bash
     flutter run -d windows
     ```

---

## Currency & Localization
All amounts are formatted dynamically using Tanzanian Shillings conventions:
- **Example:** `TSh 15,000` (thousand separators, zero decimals).

---

## License
This project is developed as a personal finance solution. Feel free to use, modify, and expand upon it.
