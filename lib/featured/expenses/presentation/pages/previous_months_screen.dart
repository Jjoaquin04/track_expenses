import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_expenses/core/themes/app_color.dart';
import 'package:track_expenses/featured/expenses/domain/entity/expense.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_bloc.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_event.dart';
import 'package:track_expenses/featured/expenses/presentation/widgets/previous_months_screen/monthly_expenses_page_view.dart';

class PreviousMonthsScreen extends StatefulWidget {
  const PreviousMonthsScreen({super.key});

  @override
  State<PreviousMonthsScreen> createState() => _PreviousMonthsScreenState();
}

class _PreviousMonthsScreenState extends State<PreviousMonthsScreen> {
  final PageController _controller = PageController(
    viewportFraction: 0.8,
    initialPage: 0,
  );

  late final ExpenseBloc _expenseBloc;

  @override
  void initState() {
    super.initState();
    _expenseBloc = context.read<ExpenseBloc>();
    // Cargar todos los gastos cuando se abre la pantalla
    _expenseBloc.add(const LoadExpensesEvent());
  }

  // Función que agrupa gastos por mes y categoría
  Map<String, Map<String, dynamic>> _groupExpensesByMonth(
    List<Expense> expenses,
  ) {
    Map<String, Map<String, dynamic>> monthlyData = {};

    for (var expense in expenses) {
      // Crear clave para el mes (ej: "2025-11")
      String monthKey =
          '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}';

      // Inicializar datos del mes si no existe
      if (!monthlyData.containsKey(monthKey)) {
        monthlyData[monthKey] = {
          'year': expense.date.year,
          'month': expense.date.month,
          'totalExpenses': 0.0,
          'totalIncome': 0.0,
          'expensesByCategory': <String, double>{},
          'incomesByCategory': <String, double>{},
        };
      }

      // Acumular según el tipo
      if (expense.type == TransactionType.expense) {
        monthlyData[monthKey]!['totalExpenses'] += expense.amount;
        monthlyData[monthKey]!['expensesByCategory'][expense.category] =
            (monthlyData[monthKey]!['expensesByCategory'][expense.category] ??
                0.0) +
            expense.amount;
      } else {
        monthlyData[monthKey]!['totalIncome'] += expense.amount;
        monthlyData[monthKey]!['incomesByCategory'][expense.category] =
            (monthlyData[monthKey]!['incomesByCategory'][expense.category] ??
                0.0) +
            expense.amount;
      }
    }

    return monthlyData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColor.primary, width: 2.5),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Meses Anteriores",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "SEGOE_UI",
            color: AppColor.primary,
          ),
        ),
      ),
      body: MonthlyExpensesPageView(
        controller: _controller,
        groupExpensesByMonth: _groupExpensesByMonth,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    // Recargar solo los gastos del mes actual cuando se salga de esta pantalla
    _expenseBloc.add(GetExpensesByMonthEvent(time: DateTime.now()));
    super.dispose();
  }
}
