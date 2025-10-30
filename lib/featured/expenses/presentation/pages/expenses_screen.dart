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
    context.read<ExpenseBloc>().add(
      GetExpensesByMonthEvent(time: DateTime.now()),
    );
  }

  Future<void> saveExpense({
    required String name,
    required String category,
    required String amount,
    required DateTime date,
    required TransactionType type,
    required int fixedExpense,
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
        date: date,
        type: type,
        fixedExpense: fixedExpense,
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
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        final isSelectionMode = state is ExpenseSelectionMode;
        final selectedCount = isSelectionMode ? state.selectedIds.length : 0;

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
          bottomNavigationBar: isSelectionMode
              ? _buildSelectionBottomBar(selectedCount)
              : null,
          floatingActionButton: isSelectionMode
              ? null
              : FloatingActionButton(
                  backgroundColor: AppColor.background,
                  hoverElevation: 2.0,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: AppColor.primary, width: 2.5),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  onPressed: _showAddExpenseBottomSheet,
                  child: const Icon(
                    Icons.add_rounded,
                    color: AppColor.primary,
                    size: 25,
                  ),
                ),
        );
      },
    );
  }

  void _handleExpenseStateChanges(BuildContext context, ExpenseState state) {
    if (state is ExpenseAdded) {
      SnackBarHelper.showSuccess(context, 'Añadido un nuevo gasto');
    } else if (state is ExpenseUpdated) {
      SnackBarHelper.showSuccess(context, 'Gasto actualizado correctamente');
    } else if (state is ExpenseDeleted) {
      SnackBarHelper.showSuccess(context, 'Gasto eliminado');
      // Después de eliminar, recargar los gastos del mes actual
      context.read<ExpenseBloc>().add(
        GetExpensesByMonthEvent(time: DateTime.now()),
      );
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

    if (state is ExpenseLoaded || state is ExpenseSelectionMode) {
      late final List<Expense> expenses;
      late final Set<String> selectedIds;

      if (state is ExpenseLoaded) {
        expenses = state.expenses;
        selectedIds = {};
      } else {
        final selectionState = state as ExpenseSelectionMode;
        expenses = selectionState.expenses;
        selectedIds = selectionState.selectedIds;
      }

      final isSelectionMode = state is ExpenseSelectionMode;

      if (expenses.isEmpty) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<ExpenseBloc>().add(
                  GetExpensesByMonthEvent(time: DateTime.now()),
                );
          },
          child: ListView(
            children: const [
              Center(
                child: Text(
                  "No hay movimientos registrados",
                  style: TextStyle(
                    fontFamily: "SEGOE_UI",
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          context.read<ExpenseBloc>().add(
                GetExpensesByMonthEvent(time: DateTime.now()),
              );
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            final isSelected = selectedIds.contains(expense.id);

            return ExpenseListItem(
              expense: expense,
              isSelectionMode: isSelectionMode,
              isSelected: isSelected,
              onLongPress: isSelectionMode
                  ? null
                  : () {
                      context.read<ExpenseBloc>().add(EnableSelectionModeEvent());
                    },
              onTap: isSelectionMode
                  ? () {
                      context.read<ExpenseBloc>().add(
                        ToggleExpenseSelectionEvent(expenseId: expense.id!),
                      );
                    }
                  : null,
            );
          },
        ),
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

  Widget _buildSelectionBottomBar(int selectedCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppColor.background,
        border: Border(
          top: BorderSide(color: AppColor.secondary.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          // Botón cancelar
          TextButton.icon(
            onPressed: () {
              context.read<ExpenseBloc>().add(DisableSelectionModeEvent());
            },
            icon: const Icon(Icons.close, color: Colors.grey),
            label: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey, fontFamily: 'SEGOE_UI'),
            ),
          ),
          const Spacer(),
          // Contador de seleccionados
          Text(
            '$selectedCount seleccionados',
            style: const TextStyle(
              fontFamily: 'SEGOE_UI',
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
          const Spacer(),
          // Botón eliminar
          if (selectedCount > 0)
            TextButton.icon(
              onPressed: () {
                _showDeleteConfirmationDialog();
              },
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red, fontFamily: 'SEGOE_UI'),
              ),
            ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: AppColor.primary, width: 2.0),
          ),
          title: const Text(
            'Confirmar eliminación',
            style: TextStyle(
              fontFamily: 'SEGOE_UI',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '¿Estás seguro de que quieres eliminar los gastos seleccionados?',
            style: TextStyle(fontFamily: 'SEGOE_UI'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey, fontFamily: 'SEGOE_UI'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<ExpenseBloc>().add(DeleteSelectedExpensesEvent());
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red, fontFamily: 'SEGOE_UI'),
              ),
            ),
          ],
        );
      },
    );
  }
}
