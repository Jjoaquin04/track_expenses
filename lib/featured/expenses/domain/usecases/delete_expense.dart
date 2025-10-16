import 'package:dartz/dartz.dart';
import 'package:track_expenses/core/errors/failure.dart';
import 'package:track_expenses/core/usecases/usecase.dart';
import 'package:track_expenses/featured/expenses/domain/entity/expense.dart';
import 'package:track_expenses/featured/expenses/domain/repository/expense_repository.dart';

class DeleteExpense extends Usecase<void, Expense> {
  final ExpenseRepository repository;

  DeleteExpense(this.repository);

  @override
  Future<Either<Failure, void>> call(Expense expense) {
    return repository.deleteExpense(expense);
  }
}
