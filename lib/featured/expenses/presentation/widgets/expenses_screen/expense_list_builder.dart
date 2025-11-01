import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_expenses/core/themes/app_color.dart';
import 'package:track_expenses/featured/expenses/domain/entity/expense.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_bloc.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_event.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_state.dart';
import 'package:track_expenses/featured/expenses/presentation/widgets/expenses_screen/expense_list_item.dart';

class ExpenseListBuilder extends StatelessWidget {
  const ExpenseListBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
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
              color: AppColor.primary,
              onRefresh: () async {
                context.read<ExpenseBloc>().add(
                  GetExpensesByMonthEvent(time: DateTime.now()),
                );
              },
              child: ListView(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Text(
                        "No hay movimientos registrados",
                        style: TextStyle(
                          fontFamily: "SEGOE_UI",
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColor.primary,
            onRefresh: () async {
              context.read<ExpenseBloc>().add(
                GetExpensesByMonthEvent(time: DateTime.now()),
              );
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
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
                          context.read<ExpenseBloc>().add(
                            EnableSelectionModeEvent(),
                          );
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
      },
    );
  }
}
