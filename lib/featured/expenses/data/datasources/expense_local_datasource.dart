import 'package:track_expenses/featured/expenses/data/expense_model.dart';

abstract class ExpenseLocalDataSource {
  Future<void> addExpense(ExpenseModel expense);
  List<ExpenseModel> getAllExpenses();
  Future<void> updateExpense(int index, ExpenseModel expense);
  Future<void> deleteExpense(int index);
  double getTotalExpenses();
}
