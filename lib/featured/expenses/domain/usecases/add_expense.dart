import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:track_expenses/core/errors/failure.dart';
import 'package:track_expenses/core/usecases/usecase.dart';
import 'package:track_expenses/featured/expenses/domain/entity/expense.dart';
import 'package:track_expenses/featured/expenses/domain/repository/expense_repository.dart';

class AddExpense extends Usecase<Expense, ExpenseParams> {
  final ExpenseRepository repository;
  AddExpense(this.repository);

  @override
  Future<Either<Failure, Expense>> call(ExpenseParams params) {
    return repository.addExpense(
      params.expenseOwner,
      params.expenseName,
      params.amount,
      params.category,
      params.date,
      params.type,
      params.fixedExpense,
    );
  }
}

class ExpenseParams extends Equatable {
  final String expenseOwner;
  final String expenseName;
  final double amount;
  final String category;
  final DateTime date;
  final TransactionType type;
  final int fixedExpense;

  const ExpenseParams({
    required this.expenseOwner,
    required this.expenseName,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    required this.fixedExpense,
  });

  @override
  List<Object?> get props => [
    expenseOwner,
    expenseName,
    amount,
    category,
    date,
    type,
    fixedExpense,
  ];
}
