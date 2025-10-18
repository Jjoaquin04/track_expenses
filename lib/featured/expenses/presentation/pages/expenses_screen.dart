import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_expenses/core/themes/app_color.dart';
import 'package:track_expenses/core/utils/user_config.dart';
import 'package:track_expenses/featured/expenses/domain/entity/expense.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_bloc.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_event.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_state.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => ExpensesScreenState();
}

class ExpensesScreenState extends State<ExpensesScreen> {
  @override
  void initState() {
    super.initState();

    //Cuando se abre la pantalla, le dice al Bloc, dame todos los gastos
    context.read<ExpenseBloc>().add(const LoadExpensesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 4,
        shadowColor: AppColor.secondary.withValues(alpha: 0.05),
        title: FutureBuilder<String>(
          future: UserConfig.getUserName(),
          builder: (context, snapshot) {
            final userName = snapshot.data ?? 'Usuario';

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hola $userName',
                  style: const TextStyle(
                    color: AppColor.primary,
                    fontFamily: 'SEGOE_UI',
                    fontWeight: FontWeight.w100,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(width: 12.0),
                Icon(Icons.waving_hand_outlined, color: AppColor.primary),
              ],
            );
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
              // Calcular totales separados
              double totalExpenses = 0.0;
              double totalIncome = 0.0;
              double currentBalance = 0.0;

              if (state is ExpenseLoaded && state.expenses.isNotEmpty) {
                // Separar gastos e ingresos
                totalExpenses = state.expenses
                    .where((e) => e.type == TransactionType.expense)
                    .fold(0.0, (sum, expense) => sum + expense.amount);

                totalIncome = state.expenses
                    .where((e) => e.type == TransactionType.income)
                    .fold(0.0, (sum, expense) => sum + expense.amount);
              }

              return FutureBuilder<double>(
                future: UserConfig.getInitialBalance(),
                builder: (context, balanceSnapshot) {
                  final initialBalance = balanceSnapshot.data ?? 0.0;

                  // Balance actual = Balance inicial + Ingresos - Gastos
                  currentBalance = initialBalance + totalIncome - totalExpenses;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 20.0,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Texto "Seguimiento" - Expanded para evitar overflow
                            Expanded(
                              child: const Text(
                                "Seguimiento de Gastos Personales",
                                style: TextStyle(
                                  fontFamily: "SEGOE_UI",
                                  fontSize: 35,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Container 1
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColor.primary.withValues(alpha: 0.05),
                                border: Border.all(
                                  color: AppColor.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Total",
                                      style: TextStyle(
                                        fontFamily: "SEGOE_UI",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "\$${currentBalance.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontFamily: "SEGOE_UI",
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Segunda fila: Container Gastos + Container Ingresos
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Container Gastos (Rojo, flecha abajo)
                            Expanded(
                              child: Container(
                                height: 100,
                                margin: const EdgeInsets.only(right: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.arrow_downward,
                                            color: Colors.red,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            "Gastos",
                                            style: TextStyle(
                                              fontFamily: "SEGOE_UI",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "\$${totalExpenses.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontFamily: "SEGOE_UI",
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Container Ingresos (Verde, flecha arriba)
                            Expanded(
                              child: Container(
                                height: 100,
                                margin: const EdgeInsets.only(left: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.green.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.arrow_upward,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            "Ingresos",
                                            style: TextStyle(
                                              fontFamily: "SEGOE_UI",
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "\$${totalIncome.toStringAsFixed(2)}",
                                        style: const TextStyle(
                                          fontFamily: "SEGOE_UI",
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),
          Container(
            height: 2,
            width: MediaQuery.of(context).size.width * 0.9,
            color: AppColor.secondary.withValues(alpha: 0.3),
          ),
          Expanded(
            child: BlocConsumer<ExpenseBloc, ExpenseState>(
              listener: (context, state) => {
                if (state is ExpenseAdded)
                  {SnackBar(content: const Text('Añadido un nuevo gasto'))},

                if (state is ExpenseUpdated)
                  {
                    SnackBar(
                      content: const Text('Gasto actualizado correctamente'),
                    ),
                  },

                if (state is ExpenseDeleted)
                  {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Gasto eliminado'))),
                  },

                if (state is ExpenseError)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.message}')),
                    ),
                  },
              },
              builder: (context, state) {
                if (state is ExpenseInitial) {
                  return Center(
                    child: Text("Comienza añadiendo un nuevo gasto o ingreso"),
                  );
                }
                if (state is ExpenseLoaded) {
                  final expenses = state.expenses;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: ListView.builder(
                      itemCount: expenses.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, int index) {
                        final expense = expenses[index];
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Columna izquierda: Fecha y Categoría
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Fecha
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${expense.date.day}/${expense.date.month}/${expense.date.year}',
                                        style: TextStyle(
                                          fontFamily: 'SEGOE_UI',
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Categoría
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.secondary.withValues(
                                        alpha: 0.8,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      expense.category,
                                      style: const TextStyle(
                                        fontFamily: "SEGOE_UI",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),

                              // Columna central: Nombre del gasto y Precio
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Nombre del gasto
                                    Text(
                                      expense.nameExpense,
                                      style: const TextStyle(
                                        fontFamily: "SEGOE_UI",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // Precio
                                    Text(
                                      expense.type == TransactionType.expense
                                          ? "- \$${expense.amount.toStringAsFixed(2)}"
                                          : "\$${expense.amount.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontFamily: "SEGOE_UI",
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
                return Center(child: const Text("Estado desconocido"));
              },
            ),
          ),
        ],
      ),
    );
  }
}
