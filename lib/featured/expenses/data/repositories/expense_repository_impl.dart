import 'package:dartz/dartz.dart';
import 'package:nostra/core/errors/exception.dart';
import 'package:nostra/core/errors/failure.dart';
import 'package:nostra/featured/expenses/data/datasources/expense_local_datasource.dart';
import 'package:nostra/featured/expenses/data/expense_model.dart';
import 'package:nostra/featured/expenses/domain/entity/expense.dart';
import 'package:nostra/featured/expenses/domain/repository/expense_repository.dart';

/// Implementación concreta del repositorio
/// Conecta la capa de dominio con la capa de datos
/// Convierte Exceptions (técnicas) en Failures (semánticas)
class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;

  ExpenseRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Expense>> addExpense(
    String expenseOwner,
    String expenseName,
    double amount,
    String category,
    DateTime date,
    TransactionType type,
    int fixedExpense,
  ) async {
    try {
      // Crear el modelo
      final model = ExpenseModel(
        expenseOwner: expenseOwner,
        expenseName: expenseName,
        amount: amount,
        category: category,
        date: date,
        type: type == TransactionType.expense ? 0 : 1,
        fixedExpense: fixedExpense,
      );

      // Guardar en el DataSource y obtener la key
      final key = await localDataSource.addExpense(model);

      // Retornar la entidad creada con ID
      final entity = model.toEntity(id: key);
      return Right(entity);
    } on CacheException catch (e) {
      // Convertir Exception técnica en Failure semántica
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpenses() async {
    try {
      // Obtener modelos del DataSource
      final modelsMap = localDataSource.getAllExpenses();

      // Convertir de Modelos a Entidades manteniendo las keys como IDs
      final entities = modelsMap.entries
          .map((entry) => entry.value.toEntity(id: entry.key))
          .toList();

      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateExpense(Expense expense) async {
    try {
      // Validar que tenga ID
      if (expense.id == null) {
        return const Left(
          ValidationFailure('El gasto debe tener un ID para actualizarlo'),
        );
      }

      // Convertir ID string a int
      final index = int.tryParse(expense.id!);
      if (index == null) {
        return const Left(ValidationFailure('ID de gasto inválido'));
      }

      // Convertir a modelo y actualizar
      final model = ExpenseModel.fromEntity(expense);
      await localDataSource.updateExpense(expense.id!, model);

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteExpense(Expense expense) async {
    try {
      // Validar que tenga ID
      if (expense.id == null) {
        return const Left(
          ValidationFailure('El gasto debe tener un ID para eliminarlo'),
        );
      }

      // Convertir ID string a int (no es necesario, ahora usamos String directamente)
      await localDataSource.deleteExpense(expense.id!);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Método auxiliar - No está en el contrato del Repository
  Future<Either<Failure, double>> getTotalExpenses() async {
    try {
      final total = localDataSource.getTotalExpenses();
      return Right(total);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpensesByMonth(
    DateTime date,
  ) async {
    try {
      final modelsMap = localDataSource.getExpensesByMonth(date);
      final entities = modelsMap.entries
          .map((entry) => entry.value.toEntity(id: entry.key))
          .toList();
      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
