import 'package:dartz/dartz.dart';
import 'package:track_expenses/core/errors/failure.dart';
import 'package:track_expenses/core/usecases/usecase.dart';
import 'package:track_expenses/featured/expenses/domain/entity/expense.dart';
import 'package:track_expenses/featured/expenses/domain/repository/expense_repository.dart';

class GetExpenses extends Usecase<List<Expense>, NoParams> {
  final ExpenseRepository repository;

  GetExpenses(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(NoParams params) {
    return repository.getExpenses();
  }
}
