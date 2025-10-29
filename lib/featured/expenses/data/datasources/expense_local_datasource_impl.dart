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
  Future<String> addExpense(ExpenseModel expense) async {
    try {
      final box = _getBox();
      final key = await box.add(expense);
      return key.toString();
    } catch (e) {
      throw CacheException('Error al guardar el gasto');
    }
  }

  @override
  Future<void> deleteExpense(String key) async {
    try {
      final box = _getBox();
      final keyInt = int.tryParse(key);
      if (keyInt == null) {
        throw CacheException('Key inválida para eliminar gasto');
      }
      await box.delete(keyInt);
    } catch (e) {
      throw CacheException('Error al eliminar el gasto');
    }
  }

  @override
  Map<String, ExpenseModel> getAllExpenses() {
    try {
      final box = _getBox();
      return box.toMap().map((key, value) => MapEntry(key.toString(), value));
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
  Future<void> updateExpense(String key, ExpenseModel expense) async {
    try {
      final box = _getBox();
      final keyInt = int.tryParse(key);
      if (keyInt == null) {
        throw CacheException('Key inválida para actualizar gasto');
      }
      await box.put(keyInt, expense);
    } catch (e) {
      throw CacheException('Error al actualizar el gasto: $e');
    }
  }

  @override
  Map<String, ExpenseModel> getExpensesByMonth(DateTime time) {
    try {
      final box = _getBox();
      // Crear fecha de inicio del mes
      final startOfMonth = DateTime(time.year, time.month, 1);
      return box
          .toMap()
          .map((key, value) => MapEntry(key.toString(), value))
          .entries
          .where(
            (entry) =>
                // Gastos del mes actual
                (entry.value.date.year == time.year &&
                    entry.value.date.month == time.month) ||
                // Gastos fijos de meses anteriores
                (entry.value.fixedExpense == 1 &&
                    entry.value.date.isBefore(startOfMonth)),
          )
          .fold<Map<String, ExpenseModel>>(
            {},
            (map, entry) => map..[entry.key] = entry.value,
          );
    } catch (e) {
      throw CacheException("Error al obtener los gastos de este mes");
    }
  }
}
