import 'package:hive/hive.dart';
import 'package:track_expenses/core/constant/hive_constants.dart';
import 'package:track_expenses/core/errors/exception.dart';
import 'package:track_expenses/featured/expenses/data/datasources/expense_local_datasource.dart';
import 'package:track_expenses/featured/expenses/data/expense_model.dart';

class ExpenseLocalDatasourceImpl implements ExpenseLocalDataSource {
  Box<ExpenseModel> _getBox() {
    try {
      return Hive.box<ExpenseModel>(HiveConstants.expenseBox);
    } catch (e) {
      throw CacheException('No se ha podido acceder a la db: $e');
    }
  }

  @override
  Future<void> addExpense(ExpenseModel expense) async {
    try {
      final box = _getBox();
      await box.add(expense);
    } catch (e) {
      throw CacheException('Error al guardar el gasto');
    }
  }

  @override
  Future<void> deleteExpense(int index) async {
    try {
      final box = _getBox();
      await box.deleteAt(index);
    } catch (e) {
      throw CacheException('Error al eleminar el gasto');
    }
  }

  @override
  List<ExpenseModel> getAllExpenses() {
    try {
      final box = _getBox();
      return box.values.toList();
    } catch (e) {
      throw CacheException('Error al obtener todos los gastos');
    }
  }

  @override
  double getTotalExpenses() {
    try {
      final box = _getBox();
      return box.values.fold(0.0, (sum, expense) => sum + expense.amount);
    } catch (e) {
      throw CacheException('Error al calcular el total: $e');
    }
  }

  @override
  Future<void> updateExpense(int index, ExpenseModel expense) async {
    try {
      final box = _getBox();
      if (index < 0 || index >= box.length) {
        throw CacheException('Índice fuera de rango: $index');
      }
      await box.putAt(index, expense);
    } catch (e) {
      throw CacheException('Error al actualizar el gasto: $e');
    }
  }
}
