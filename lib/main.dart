import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:track_expenses/core/constant/hive_constants.dart';
import 'package:track_expenses/core/dependency_injection/dependecy_injection.dart';
import 'package:track_expenses/featured/expenses/data/expense_model.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_bloc.dart';
import 'package:track_expenses/featured/expenses/presentation/pages/expenses_screen.dart';

void main() async {
  // Initialize Hive
  await Hive.initFlutter();

  // Registramos el adaptor del file generado automaticamente
  Hive.registerAdapter(ExpenseModelAdapter());

  await Hive.openBox<ExpenseModel>(HiveConstants.expenseBox);

  setUpDependencyInjection();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<ExpenseBloc>(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ExpensesScreen(),
      ),
    );
  }
}
