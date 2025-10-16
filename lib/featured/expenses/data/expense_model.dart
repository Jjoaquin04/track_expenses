import 'package:hive/hive.dart';
import 'package:track_expenses/core/constant/hive_constants.dart';
import 'package:track_expenses/featured/expenses/domain/entity/expense.dart';

part 'expense_model.g.dart';

@HiveType(typeId: HiveConstants.expenseTypeId)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  late String expenseOwner;

  @HiveField(1)
  late String expenseName;

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late String category;

  @HiveField(4)
  late DateTime date;

  ExpenseModel({
    required this.expenseOwner,
    required this.expenseName,
    required this.amount,
    required this.category,
    required this.date,
  });

  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      expenseOwner: expense.ownerExpense,
      expenseName: expense.nameExpense,
      amount: expense.amount,
      category: expense.category,
      date: expense.date,
    );
  }

  Expense toEntity({String? id}) {
    return Expense(
      id: id,
      ownerExpense: expenseOwner,
      nameExpense: expenseName,
      amount: amount,
      category: category,
      date: date,
    );
  }
}
