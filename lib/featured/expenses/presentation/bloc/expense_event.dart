import 'package:equatable/equatable.dart';
import 'package:track_expenses/featured/expenses/domain/entity/expense.dart';

/// Clase base para todos los eventos de gastos
abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

/// Evento: Cargar todos los gastos
class LoadExpensesEvent extends ExpenseEvent {
  const LoadExpensesEvent();
}

/// Evento: Agregar un nuevo gasto
class AddExpenseEvent extends ExpenseEvent {
  final String expenseOwner;
  final String expenseName;
  final double amount;
  final String category;
  final DateTime date;

  const AddExpenseEvent({
    required this.expenseOwner,
    required this.expenseName,
    required this.amount,
    required this.category,
    required this.date,
  });

  @override
  List<Object?> get props => [
    expenseOwner,
    expenseName,
    amount,
    category,
    date,
  ];
}

/// Evento: Actualizar un gasto existente
class UpdateExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const UpdateExpenseEvent({required this.expense});

  @override
  List<Object?> get props => [expense];
}

/// Evento: Eliminar un gasto
class DeleteExpenseEvent extends ExpenseEvent {
  final Expense expense;

  const DeleteExpenseEvent({required this.expense});

  @override
  List<Object?> get props => [expense];
}

/// Evento: Filtrar gastos por categoría
class FilterExpensesByCategoryEvent extends ExpenseEvent {
  final String category;

  const FilterExpensesByCategoryEvent({required this.category});

  @override
  List<Object?> get props => [category];
}

/// Evento: Obtener el total de gastos
class GetTotalExpensesEvent extends ExpenseEvent {
  const GetTotalExpensesEvent();
}
