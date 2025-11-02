import 'package:get_it/get_it.dart';
import 'package:track_expenses/core/localization/locale_cubit.dart';
import 'package:track_expenses/featured/expenses/data/datasources/expense_local_datasource.dart';
import 'package:track_expenses/featured/expenses/data/datasources/expense_local_datasource_impl.dart';
import 'package:track_expenses/featured/expenses/data/repositories/expense_repository_impl.dart';
import 'package:track_expenses/featured/expenses/domain/repository/expense_repository.dart';
import 'package:track_expenses/featured/expenses/domain/usecases/add_expense.dart';
import 'package:track_expenses/featured/expenses/domain/usecases/delete_expense.dart';
import 'package:track_expenses/featured/expenses/domain/usecases/get_expenses.dart';
import 'package:track_expenses/featured/expenses/domain/usecases/update_expense.dart';
import 'package:track_expenses/featured/expenses/domain/usecases/get_expenses_by_month.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/bloc.dart';

final getIt = GetIt.instance;

void setUpDependencyInjection() {
  getIt.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDatasourceImpl(),
  );

  getIt.registerLazySingleton<ExpenseRepository>(
    () =>
        ExpenseRepositoryImpl(localDataSource: getIt<ExpenseLocalDataSource>()),
  );

  getIt.registerLazySingleton(() => GetExpenses(getIt<ExpenseRepository>()));

  getIt.registerLazySingleton(() => AddExpense(getIt<ExpenseRepository>()));

  getIt.registerLazySingleton(() => DeleteExpense(getIt<ExpenseRepository>()));

  getIt.registerLazySingleton(() => UpdateExpense(getIt<ExpenseRepository>()));

  getIt.registerLazySingleton(
    () => GetExpensesByMonth(getIt<ExpenseRepository>()),
  );

  getIt.registerFactory<ExpenseBloc>(
    () => ExpenseBloc(
      getExpensesUseCase: getIt(),
      addExpenseUseCase: getIt(),
      updateExpenseUseCase: getIt(),
      deleteExpenseUseCase: getIt(),
      getExpensesByMonthUseCase: getIt(),
    ),
  );

  // Locale Cubit (singleton for app-wide language state)
  getIt.registerLazySingleton<LocaleCubit>(() => LocaleCubit());
}
