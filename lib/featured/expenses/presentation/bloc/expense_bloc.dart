import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_expenses/core/usecases/usecase.dart';
import 'package:track_expenses/featured/expenses/domain/usecases/add_expense.dart';
import 'package:track_expenses/featured/expenses/domain/usecases/delete_expense.dart';
import 'package:track_expenses/featured/expenses/domain/usecases/get_expenses.dart';
import 'package:track_expenses/featured/expenses/domain/usecases/update_expense.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_event.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetExpenses getExpensesUseCase;
  final AddExpense addExpenseUseCase;
  final UpdateExpense updateExpenseUseCase;
  final DeleteExpense deleteExpenseUseCase;

  ExpenseBloc({
    required this.getExpensesUseCase,
    required this.addExpenseUseCase,
    required this.updateExpenseUseCase,
    required this.deleteExpenseUseCase,
  }) : super(const ExpenseInitial()) {
    // Registrar manejadores de eventos
    on<LoadExpensesEvent>(_onLoadExpenses);
    on<AddExpenseEvent>(_onAddExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
  }

  /// Cargar todos los gastos
  Future<void> _onLoadExpenses(
    LoadExpensesEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await getExpensesUseCase(const NoParams());

    result.fold((failure) => emit(ExpenseError(message: failure.message)), (
      expenses,
    ) {
      // Calcular el total
      final total = expenses.fold<double>(
        0.0,
        (sum, expense) => sum + expense.amount,
      );

      emit(ExpenseLoaded(expenses: expenses, totalAmount: total));
    });
  }

  /// Agregar un nuevo gasto
  Future<void> _onAddExpense(
    AddExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await addExpenseUseCase(
      ExpenseParams(
        expenseOwner: event.expenseOwner,
        expenseName: event.expenseName,
        amount: event.amount,
        category: event.category,
        date: event.date,
        type: event.type,
      ),
    );

    result.fold((failure) => emit(ExpenseError(message: failure.message)), (
      expense,
    ) {
      emit(ExpenseAdded(expense: expense));
      // Recargar la lista de gastos
      add(const LoadExpensesEvent());
    });
  }

  /// Actualizar un gasto existente
  Future<void> _onUpdateExpense(
    UpdateExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await updateExpenseUseCase(event.expense);

    result.fold((failure) => emit(ExpenseError(message: failure.message)), (_) {
      emit(ExpenseUpdated(expense: event.expense));
      // Recargar la lista de gastos
      add(const LoadExpensesEvent());
    });
  }

  /// Eliminar un gasto
  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await deleteExpenseUseCase(event.expense);

    result.fold((failure) => emit(ExpenseError(message: failure.message)), (_) {
      emit(const ExpenseDeleted());
      // Recargar la lista de gastos
      add(const LoadExpensesEvent());
    });
  }
}
