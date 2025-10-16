import 'package:dartz/dartz.dart';
import 'package:track_expenses/core/errors/exception.dart';
import 'package:track_expenses/core/errors/failure.dart';
import 'package:track_expenses/featured/expenses/data/datasources/expense_local_datasource.dart';
import 'package:track_expenses/featured/expenses/data/expense_model.dart';
import 'package:track_expenses/featured/expenses/domain/entity/expense.dart';
import 'package:track_expenses/featured/expenses/domain/repository/expense_repository.dart';

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
  ) async {
    try {
      // Crear el modelo
      final model = ExpenseModel(
        expenseOwner: expenseOwner,
        expenseName: expenseName,
        amount: amount,
        category: category,
        date: date,
      );

      // Guardar en el DataSource
      await localDataSource.addExpense(model);

      // Retornar la entidad creada
      final entity = model.toEntity();
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
      final models = localDataSource.getAllExpenses();

      // Convertir de Modelos a Entidades con su índice como ID
      final entities = models
          .asMap()
          .entries
          .map((entry) => entry.value.toEntity(id: entry.key.toString()))
          .toList();

      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  // Método auxiliar - No está en el contrato del Repository
  Future<Either<Failure, Expense>> getExpense(int index) async {
    try {
      final models = localDataSource.getAllExpenses();
      
      if (index < 0 || index >= models.length) {
        return const Left(NotFoundFailure('Gasto no encontrado'));
      }
      
      final model = models[index];
      final entity = model.toEntity(id: index.toString());
      return Right(entity);
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
      await localDataSource.updateExpense(index, model);
      
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

      // Convertir ID string a int
      final index = int.tryParse(expense.id!);
      if (index == null) {
        return const Left(ValidationFailure('ID de gasto inválido'));
      }

      await localDataSource.deleteExpense(index);
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

  // Método auxiliar - No está en el contrato del Repository
  Future<Either<Failure, List<Expense>>> getExpensesByCategory(
    String category,
  ) async {
    try {
      // Obtener todos los gastos y filtrar manualmente
      final models = localDataSource.getAllExpenses();
      final filtered = models
          .where((model) =>
              model.category.toLowerCase() == category.toLowerCase())
          .toList();

      final entities = filtered
          .asMap()
          .entries
          .map((entry) => entry.value.toEntity(id: entry.key.toString()))
          .toList();

      return Right(entities);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}