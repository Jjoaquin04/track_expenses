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
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final categoryController = TextEditingController();
  TransactionType type = TransactionType.expense;

  @override
  void initState() {
    super.initState();

    context.read<ExpenseBloc>().add(const LoadExpensesEvent());
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    categoryController.dispose();

    super.dispose();
  }

  Future<void> saveExpense() async {
    if (nameController.text.trim().isEmpty ||
        categoryController.text.trim().isEmpty ||
        amountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Todos los campos son requeridos",
            style: TextStyle(color: Colors.white, fontFamily: "SEGOE_UI"),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<ExpenseBloc>().add(
      AddExpenseEvent(
        expenseOwner: await UserConfig.getUserName(),
        expenseName: nameController.text.trim(),
        amount: double.tryParse(amountController.text.trim())!,
        category: categoryController.text.trim(),
        date: DateTime.now(),
        type: type,
      ),
    );
    if (mounted) {
      Navigator.pop(context);
    }
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
              mainAxisSize: MainAxisSize.min,
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
        actions: [
          BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
              double totalExpenses = 0.0;
              double totalIncome = 0.0;

              if (state is ExpenseLoaded && state.expenses.isNotEmpty) {
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
                  final currentBalance =
                      initialBalance + totalIncome - totalExpenses;

                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            fontFamily: "SEGOE_UI",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColor.secondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "\$${currentBalance.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontFamily: "SEGOE_UI",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
              // Calcular totales separados
              double totalExpenses = 0.0;
              double totalIncome = 0.0;

              if (state is ExpenseLoaded && state.expenses.isNotEmpty) {
                // Separar gastos e ingresos
                totalExpenses = state.expenses
                    .where((e) => e.type == TransactionType.expense)
                    .fold(0.0, (sum, expense) => sum + expense.amount);

                totalIncome = state.expenses
                    .where((e) => e.type == TransactionType.income)
                    .fold(0.0, (sum, expense) => sum + expense.amount);
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0,
                    ),
                    child: const Text(
                      "Seguimiento de Gastos Personales",
                      style: TextStyle(
                        fontFamily: "SEGOE_UI",
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                      ),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
          ),
          const SizedBox(height: 20),
          Divider(
            height: 2,
            color: AppColor.secondary.withValues(alpha: 0.3),
            indent: 10,
            endIndent: 10,
          ),
          Expanded(
            child: BlocConsumer<ExpenseBloc, ExpenseState>(
              listener: (context, state) => {
                if (state is ExpenseAdded)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Añadido un nuevo gasto',
                          style: TextStyle(
                            color: AppColor.primary,
                            fontFamily: "SEGOE_UI",
                          ),
                        ),
                      ),
                    ),
                  },

                if (state is ExpenseUpdated)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Gasto actualizado correctamente',
                          style: TextStyle(
                            color: AppColor.primary,
                            fontFamily: "SEGOE_UI",
                          ),
                        ),
                      ),
                    ),
                  },

                if (state is ExpenseDeleted)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Gasto eliminado',
                          style: TextStyle(
                            color: AppColor.primary,
                            fontFamily: "SEGOE_UI",
                          ),
                        ),
                      ),
                    ),
                  },

                if (state is ExpenseError)
                  {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error: ${state.message}',
                          style: TextStyle(
                            color: AppColor.primary,
                            fontFamily: "SEGOE_UI",
                          ),
                        ),
                      ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.background,
        hoverElevation: 2.0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: AppColor.primary, // Color del borde
            width: 2.5, // Grosor del borde
          ),
          borderRadius: BorderRadiusGeometry.circular(12.0),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            //backgroundColor: Colors.transparent,
            builder: (BuildContext context) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.75,
                decoration: BoxDecoration(
                  color: AppColor.background,
                  border: Border.all(color: AppColor.primary, width: 3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.0),
                    topRight: Radius.circular(24.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título del bottom sheet
                      Center(
                        child: Container(
                          width: 50,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppColor.secondary.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Nueva Transacción",
                        style: TextStyle(
                          fontFamily: "SEGOE_UI",
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tipo de transacción (Gasto o Ingreso)
                      const Text(
                        "Tipo",
                        style: TextStyle(
                          fontFamily: "SEGOE_UI",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.secondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownMenu<TransactionType>(
                        onSelected: (TransactionType? value) {
                          setState(() {
                            type = value ?? TransactionType.expense;
                          });
                        },
                        width: MediaQuery.of(context).size.width - 48,
                        initialSelection: TransactionType.expense,
                        textStyle: const TextStyle(
                          fontFamily: "SEGOE_UI",
                          fontSize: 16,
                        ),
                        inputDecorationTheme: InputDecorationTheme(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColor.secondary.withValues(alpha: 0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColor.secondary.withValues(alpha: 0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColor.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(
                            value: TransactionType.expense,
                            label: "Gasto",
                            leadingIcon: Icon(
                              Icons.arrow_downward,
                              color: Colors.red,
                            ),
                          ),
                          DropdownMenuEntry(
                            value: TransactionType.income,
                            label: "Ingreso",
                            leadingIcon: Icon(
                              Icons.arrow_upward,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Nombre del gasto/ingreso
                      const Text(
                        "Nombre",
                        style: TextStyle(
                          fontFamily: "SEGOE_UI",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.secondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Ej: Compra de supermercado",
                          hintStyle: TextStyle(
                            color: AppColor.secondary.withValues(alpha: 0.5),
                            fontFamily: "SEGOE_UI",
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColor.secondary.withValues(alpha: 0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColor.secondary.withValues(alpha: 0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColor.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontFamily: "SEGOE_UI",
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Categoría
                      const Text(
                        "Categoría",
                        style: TextStyle(
                          fontFamily: "SEGOE_UI",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.secondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: categoryController,
                        decoration: InputDecoration(
                          hintText: "Ej: Alimentación, Transporte",
                          hintStyle: TextStyle(
                            color: AppColor.secondary.withValues(alpha: 0.5),
                            fontFamily: "SEGOE_UI",
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColor.secondary.withValues(alpha: 0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColor.secondary.withValues(alpha: 0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColor.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontFamily: "SEGOE_UI",
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Monto
                      const Text(
                        "Monto",
                        style: TextStyle(
                          fontFamily: "SEGOE_UI",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.secondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          hintText: "0.00",
                          prefixText: "\$ ",
                          prefixStyle: const TextStyle(
                            color: AppColor.primary,
                            fontFamily: "SEGOE_UI",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          hintStyle: TextStyle(
                            color: AppColor.secondary.withValues(alpha: 0.5),
                            fontFamily: "SEGOE_UI",
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColor.secondary.withValues(alpha: 0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColor.secondary.withValues(alpha: 0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColor.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontFamily: "SEGOE_UI",
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),

                      // Botón de guardar
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            saveExpense();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            "Guardar",
                            style: TextStyle(
                              fontFamily: "SEGOE_UI",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add_rounded, color: AppColor.primary, size: 25),
      ),
    );
  }
}
