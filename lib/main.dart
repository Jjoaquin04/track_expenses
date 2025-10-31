import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'package:track_expenses/core/constant/hive_constants.dart';
import 'package:track_expenses/core/dependency_injection/dependecy_injection.dart';
import 'package:track_expenses/core/utils/user_config.dart';
import 'package:track_expenses/featured/expenses/data/expense_model.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_bloc.dart';
import 'package:track_expenses/featured/expenses/presentation/pages/expenses_screen.dart';
import 'package:track_expenses/featured/expenses/presentation/pages/welcome_screen.dart';

// Callback de fondo para HomeWidget
@pragma('vm:entry-point')
void backgroundCallback(Uri? uri) async {
  try {
    // 1. Inicializar todo lo necesario en el Isolate de fondo
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(ExpenseModelAdapter().typeId)) {
      Hive.registerAdapter(ExpenseModelAdapter());
    }

    // 2. Abrir las cajas de Hive
    final expenseBox = await Hive.openBox<ExpenseModel>(
      HiveConstants.expenseBox,
    );
    final userConfigBox = await Hive.openBox('user_config');

    // 3. Obtener los datos (string JSON) guardados desde Kotlin
    final dataString = await HomeWidget.getWidgetData<String>('expense_data');

    if (dataString == null) {
      return;
    }

    // 4. Parsear el JSON
    final data = jsonDecode(dataString) as Map<String, dynamic>;

    final amountStr = data['amount'] as String?;
    final amount = amountStr != null ? double.tryParse(amountStr) : null;
    final dateStr = data['date'] as String?;
    final date = (dateStr != null) ? DateTime.tryParse(dateStr) : null;
    final typeStr = data['type'] as String?;
    final fixedExpense = data['fixedExpense'] as int?;

    if (amount == null || date == null || typeStr == null) {
      return;
    }

    // 5. Obtener el dueño del gasto
    final expenseOwner = userConfigBox.get(
      'user_name',
      defaultValue: 'Usuario',
    );

    // 6. Crear el modelo
    final model = ExpenseModel(
      expenseOwner: expenseOwner,
      expenseName: data['name'] as String? ?? '',
      amount: amount,
      category: data['category'] as String? ?? 'Otros',
      date: date,
      type: typeStr == "expense" ? 0 : 1,
      fixedExpense: fixedExpense ?? 0,
    );

    // 7. Guardar en Hive
    await expenseBox.add(model);

    // 8. Cerrar cajas en el Isolate de fondo
    await expenseBox.close();
    await userConfigBox.close();

    await HomeWidget.saveWidgetData<String>('expense_data', null);
  } catch (e) {
    throw Exception(e.toString());
  }
}

void main() async {
  // 1. Inicialización estándar
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Registrar el callback de HomeWidget (MODIFICADO)
  HomeWidget.registerInteractivityCallback(backgroundCallback);

  // 3. Inicialización de Hive para la app principal
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());
  await Hive.openBox<ExpenseModel>(HiveConstants.expenseBox);
  // También abrimos user_config para la app principal
  await Hive.openBox('user_config');

  // 4. Inyección de dependencias y ejecutar la app
  setUpDependencyInjection();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt.get<ExpenseBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<bool>(
          future: UserConfig.isUserConfigured(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.data == true) {
              return const ExpensesScreen();
            }
            return const WelcomeScreen();
          },
        ),
      ),
    );
  }
}
