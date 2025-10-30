import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_expenses/core/constant/hive_constants.dart';
import 'package:track_expenses/core/dependency_injection/dependecy_injection.dart';
import 'package:track_expenses/core/utils/user_config.dart';
import 'package:track_expenses/featured/expenses/data/expense_model.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_bloc.dart';
import 'package:track_expenses/featured/expenses/presentation/pages/expenses_screen.dart';
import 'package:track_expenses/featured/expenses/presentation/pages/welcome_screen.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final transactionId = inputData?["transactionId"];
    print('Workmanager: Task received with transactionId: $transactionId');
    if (transactionId == null) {
      return Future.value(false);
    }
    try {
      // CORRECCIÓN 1 (Crítica): Inicializar el binding para plugins nativos en el Isolate.
      // Esta línea es la que soluciona el 'FAILURE'.
      WidgetsFlutterBinding.ensureInitialized();

      final prefs = await SharedPreferences.getInstance();

      final amountStr = prefs.getString("${transactionId}_amount");
      final category = prefs.getString("${transactionId}_category");
      final type = prefs.getString("${transactionId}_type");
      final dateStr = prefs.getString("${transactionId}_date");
      final name = prefs.getString("${transactionId}_name");
      final fixedExpenseStr = prefs.getString("${transactionId}_fixedExpense");
      final fixedExpense = int.tryParse(fixedExpenseStr ?? '0') ?? 0;

      print('Workmanager: Data from SharedPreferences:');
      print(
        'Workmanager: amount: $amountStr, category: $category, type: $type, date: $dateStr, name: $name, fixedExpense: $fixedExpenseStr',
      );

      if (amountStr != null &&
          type != null &&
          category != null &&
          dateStr != null &&
          name != null) {
        final amount = double.tryParse(amountStr);
        final date = DateTime.tryParse(dateStr);
        if (amount == null || date == null) {
          print('Workmanager: Failed to parse amount or date.');
          return Future.value(false);
        }

        // Inicializar Hive en el isolate (thread-safe)
        await Hive.initFlutter();

        // CORRECCIÓN 2 (Mejora): Comprobar si el adaptador ya está registrado.
        // Evita errores si la tarea se ejecuta varias veces.
        if (!Hive.isAdapterRegistered(ExpenseModelAdapter().typeId)) {
          Hive.registerAdapter(ExpenseModelAdapter());
        }

        // Abrir las cajas necesarias
        final expenseBox = await Hive.openBox<ExpenseModel>(
          HiveConstants.expenseBox,
        );
        // NOTA: Abrir 'user_config' aquí puede ser arriesgado si la app principal
        // también la tiene abierta. Pero si 'user_name' no cambia,
        // leerlo una vez está bien.
        final userConfigBox = await Hive.openBox('user_config');

        // Obtener el nombre del usuario desde la caja de configuración
        final expenseOwner = userConfigBox.get(
          'user_name',
          defaultValue: 'Usuario',
        );

        final model = ExpenseModel(
          expenseOwner: expenseOwner,
          expenseName: name,
          amount: amount,
          category: category,
          date: date,
          type: type == "expense" ? 0 : 1,
          fixedExpense: fixedExpense,
        );

        await expenseBox.add(model);
        print('Workmanager: Expense saved to Hive.');

        await expenseBox.close();
        await userConfigBox.close();

        // Limpiar los datos temporales de SharedPreferences
        await prefs.remove("${transactionId}_name");
        await prefs.remove("${transactionId}_amount");
        await prefs.remove("${transactionId}_category");
        await prefs.remove("${transactionId}_date");
        await prefs.remove("${transactionId}_type");
        await prefs.remove("${transactionId}_fixedExpense");
        print('Workmanager: Cleaned up SharedPreferences.');

        return Future.value(true);
      } else {
        print(
          'Workmanager: One or more values were null in SharedPreferences.',
        );
        return Future.value(false);
      }
    } catch (e, s) {
      // Añadido 's' para ver el StackTrace
      print('Workmanager: Error executing task: $e');
      print(s); // Imprime la pila de llamadas para más detalles
      return Future.value(false);
    }
  });
}

void main() async {
  // CORRECCIÓN 3: Esta línea DEBE ser la primera en main().
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Registramos el adaptor del file generado automaticamente
  Hive.registerAdapter(ExpenseModelAdapter());

  await Hive.openBox<ExpenseModel>(HiveConstants.expenseBox);

  setUpDependencyInjection();

  Workmanager().initialize(callbackDispatcher);

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
