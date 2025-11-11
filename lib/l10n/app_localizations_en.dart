// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeTitle => 'Welcome!';

  @override
  String get welcomeSubtitle => 'Set up your profile to get started';

  @override
  String get yourName => 'Your name';

  @override
  String get yourNameHint => 'e.g. John Doe';

  @override
  String get initialBalance => 'Initial balance';

  @override
  String get initialBalanceHint => 'e.g. 1000.00';

  @override
  String get initialBalanceHelper => 'Amount of money you start with';

  @override
  String get continueButton => 'Continue';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get pleaseEnterBalance => 'Please enter an initial balance';

  @override
  String get enterValidNumber => 'Enter a valid number';

  @override
  String get balanceCannotBeNegative => 'Balance cannot be negative';

  @override
  String get hello => 'Hello';

  @override
  String get total => 'Total';

  @override
  String get personalMovementTracking => 'Personal Movement Tracking';

  @override
  String get expenses => 'Expenses';

  @override
  String get totalExpenses => 'Total Expenses';

  @override
  String get totalIncome => 'Total Income';

  @override
  String get currentBalance => 'Current Balance';

  @override
  String get noExpensesYet => 'No expenses yet';

  @override
  String get startAddingExpenses =>
      'Start adding your expenses using the + button';

  @override
  String get errorLoadingExpenses => 'Error loading expenses';

  @override
  String get retryButton => 'Retry';

  @override
  String get fixed => 'Fixed';

  @override
  String get dailyExpense => 'Daily expense';

  @override
  String get newTransaction => 'New Transaction';

  @override
  String get type => 'Type';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String get category => 'Category';

  @override
  String get name => 'Name';

  @override
  String get nameHint => 'e.g. Supermarket';

  @override
  String get amount => 'Amount';

  @override
  String get amountHint => 'e.g. 25.50';

  @override
  String get date => 'Date';

  @override
  String get dateHint => 'Select a date';

  @override
  String get isFixedExpense => 'Is it a fixed expense?';

  @override
  String get saveButton => 'Save';

  @override
  String get pleaseEnterValidAmount => 'Please enter a valid amount';

  @override
  String get pleaseSelectDate => 'Please select a date';

  @override
  String get pleaseEnterTransactionName => 'Please enter a transaction name';

  @override
  String itemsSelected(int count) {
    return '$count selected';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDelete => 'Confirm deletion';

  @override
  String get confirmDeleteMessage =>
      'Are you sure you want to delete the selected expenses?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get previousMonths => 'Previous Months';

  @override
  String monthYear(String month, int year) {
    return '$month $year';
  }

  @override
  String get noDataForMonth => 'No data for this month';

  @override
  String get expensesByCategory => 'Expenses by Category';

  @override
  String get incomeByCategory => 'Income by Category';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get categoryFood => 'Food';

  @override
  String get categoryTransport => 'Transport';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryEducation => 'Education';

  @override
  String get categoryClothing => 'Clothing';

  @override
  String get categoryOther => 'Other';

  @override
  String get categorySalary => 'Salary';

  @override
  String get categoryBonus => 'Bonus';

  @override
  String get categoryInvestment => 'Investment';

  @override
  String get categoryGift => 'Gift';

  @override
  String get categoryOtherIncome => 'Other Income';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get languageChanged => 'Language changed successfully';

  @override
  String get expenseAddedSuccess => 'Expense added successfully';

  @override
  String get expenseDeletedSuccess => 'Expense(s) deleted successfully';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get fixedTransactionInfo => 'Fixed Transaction Information';

  @override
  String get fixedTransactionDescription =>
      'This expense is marked as fixed. Fixed transactions are those that repeat monthly, meaning they are added automatically.';

  @override
  String get unpinFixedExpense => 'Deactivate Fixed Expense';

  @override
  String unpinFixedExpenseQuestion(String name) {
    return 'Do you want to convert \"$name\" into a non-fixed expense?';
  }

  @override
  String get unpinFixedExpenseWarning =>
      'This transaction will no longer appear automatically in future months.';

  @override
  String get deactivate => 'Deactivate';

  @override
  String get expenseConvertedToNonFixed => 'Expense converted to non-fixed';

  @override
  String get errorDeactivatingFixedExpense =>
      'Error deactivating fixed expense';

  @override
  String get startAddingTransactions =>
      'Start by adding a new expense or income';

  @override
  String get noTransactionsRecorded => 'No transactions recorded';

  @override
  String get unknownState => 'Unknown state';
}
