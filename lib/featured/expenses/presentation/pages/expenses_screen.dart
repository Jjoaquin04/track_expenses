import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_expenses/core/themes/app_color.dart';
import 'package:track_expenses/core/utils/snackbar_helper.dart';
import 'package:track_expenses/core/utils/user_config.dart';
import 'package:track_expenses/featured/expenses/domain/entity/expense.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_bloc.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_event.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_state.dart';
import 'package:track_expenses/featured/expenses/presentation/widgets/add_expense_bottom_sheet.dart';
import 'package:track_expenses/featured/expenses/presentation/widgets/expense_app_bar.dart';
import 'package:track_expenses/featured/expenses/presentation/widgets/expense_list_item.dart';
import 'package:track_expenses/featured/expenses/presentation/widgets/summary_cards_widget.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => ExpensesScreenState();
}

class ExpensesScreenState extends State<ExpensesScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ExpenseBloc>().add(const LoadExpensesEvent());
  }

  Future<void> saveExpense({
    required String name,
    required String category,
    required String amount,
    required TransactionType type,
  }) async {
    // Validar campos vacíos
    if (name.trim().isEmpty || category.isEmpty || amount.trim().isEmpty) {
      SnackBarHelper.showError(context, "Todos los campos son requeridos");
      return;
    }

    // Validar monto
    final parsedAmount = double.tryParse(amount.trim());
    if (parsedAmount == null || parsedAmount <= 0) {
      SnackBarHelper.showError(
        context,
        "Por favor ingresa un monto válido mayor a 0",
      );
      return;
    }

    // Guardar gasto
    context.read<ExpenseBloc>().add(
      AddExpenseEvent(
        expenseOwner: await UserConfig.getUserName(),
        expenseName: name.trim(),
        amount: parsedAmount,
        category: category,
        date: DateTime.now(),
        type: type,
      ),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _showAddExpenseBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddExpenseBottomSheet(onSave: saveExpense);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: const ExpenseAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SummaryCardsWidget(),
          const SizedBox(height: 20),
          Divider(
            height: 2,
            color: AppColor.secondary.withValues(alpha: 0.3),
            indent: 10,
            endIndent: 10,
          ),
          Expanded(
            child: BlocConsumer<ExpenseBloc, ExpenseState>(
              listener: _handleExpenseStateChanges,
              builder: _buildExpenseList,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.background,
        hoverElevation: 2.0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColor.primary, width: 2.5),
          borderRadius: BorderRadius.circular(12.0),
        ),
        onPressed: _showAddExpenseBottomSheet,
        child: const Icon(Icons.add_rounded, color: AppColor.primary, size: 25),
      ),
    );
  }

  void _handleExpenseStateChanges(BuildContext context, ExpenseState state) {
    if (state is ExpenseAdded) {
      SnackBarHelper.showSuccess(context, 'Añadido un nuevo gasto');
    } else if (state is ExpenseUpdated) {
      SnackBarHelper.showSuccess(context, 'Gasto actualizado correctamente');
    } else if (state is ExpenseDeleted) {
      SnackBarHelper.showSuccess(context, 'Gasto eliminado');
    } else if (state is ExpenseError) {
      SnackBarHelper.showError(context, 'Error: ${state.message}');
    }
  }

  Widget _buildExpenseList(BuildContext context, ExpenseState state) {
    if (state is ExpenseInitial) {
      return const Center(
        child: Text(
          "Comienza añadiendo un nuevo gasto o ingreso",
          style: TextStyle(
            fontFamily: "SEGOE_UI",
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    if (state is ExpenseLoaded) {
      if (state.expenses.isEmpty) {
        return const Center(
          child: Text(
            "No hay gastos registrados",
            style: TextStyle(
              fontFamily: "SEGOE_UI",
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        itemCount: state.expenses.length,
        itemBuilder: (context, index) {
          return ExpenseListItem(expense: state.expenses[index]);
        },
      );
    }

    return const Center(
      child: Text(
        "Estado desconocido",
        style: TextStyle(
          fontFamily: "SEGOE_UI",
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
    );
  }
}
