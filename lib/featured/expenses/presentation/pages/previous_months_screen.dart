import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_expenses/core/constant/date_constants.dart';
import 'package:track_expenses/core/themes/app_color.dart';
import 'package:track_expenses/featured/expenses/domain/entity/expense.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_bloc.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_event.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_state.dart';

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

  @override
  void initState() {
    super.initState();
    // Cargar todos los gastos cuando se abre la pantalla
    context.read<ExpenseBloc>().add(const LoadExpensesEvent());
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
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColor.primary, width: 2.5),
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
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.primary),
            );
          }

          if (state is ExpenseError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(
                  fontFamily: 'SEGOE_UI',
                  color: Colors.red,
                ),
              ),
            );
          }

          if (state is! ExpenseLoaded || state.expenses.isEmpty) {
            return const Center(
              child: Text(
                'No hay datos de meses anteriores',
                style: TextStyle(
                  fontFamily: 'SEGOE_UI',
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          // Agrupar gastos por mes
          final monthlyData = _groupExpensesByMonth(state.expenses);

          // Ordenar meses de más reciente a más antiguo
          final sortedMonthKeys = monthlyData.keys.toList()
            ..sort((a, b) => a.compareTo(b));

          if (sortedMonthKeys.isEmpty) {
            return const Center(
              child: Text(
                'No hay datos de meses anteriores',
                style: TextStyle(
                  fontFamily: 'SEGOE_UI',
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return SizedBox(
            height: double.infinity,
            child: PageView.builder(
              itemCount: sortedMonthKeys.length,
              controller: _controller,
              itemBuilder: (context, index) {
                final monthKey = sortedMonthKeys[index];
                final data = monthlyData[monthKey]!;

                return ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    double factor = 1;
                    if (_controller.position.hasContentDimensions) {
                      factor = 1 - (_controller.page! - index).abs();
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Center(
                        child: SizedBox(
                          height: 700 + (factor * 30),
                          child: _MonthCard(
                            month: data['month'],
                            year: data['year'],
                            totalExpenses: data['totalExpenses'],
                            totalIncome: data['totalIncome'],
                            expensesByCategory: data['expensesByCategory'],
                            incomesByCategory: data['incomesByCategory'],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    // Recargar solo los gastos del mes actual cuando se salga de esta pantalla
    context.read<ExpenseBloc>().add(
      GetExpensesByMonthEvent(time: DateTime.now()),
    );
    super.dispose();
  }
}

class _MonthCard extends StatelessWidget {
  final int month;
  final int year;
  final double totalExpenses;
  final double totalIncome;
  final Map<String, double> expensesByCategory;
  final Map<String, double> incomesByCategory;

  const _MonthCard({
    required this.month,
    required this.year,
    required this.totalExpenses,
    required this.totalIncome,
    required this.expensesByCategory,
    required this.incomesByCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: AppColor.primary,
      surfaceTintColor: AppColor.background,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColor.primary, width: 2.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mes y Año
              Center(
                child: Text(
                  "${getMonthName(month)} $year",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: "SEGOE_UI",
                    color: AppColor.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Totales
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _TotalCard(
                    label: 'Gastos',
                    amount: totalExpenses,
                    color: Colors.red,
                    icon: Icons.arrow_downward,
                  ),
                  _TotalCard(
                    label: 'Ingresos',
                    amount: totalIncome,
                    color: Colors.green,
                    icon: Icons.arrow_upward,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Gastos por categoría
              if (expensesByCategory.isNotEmpty) ...[
                const Divider(thickness: 1.5),
                const SizedBox(height: 16),
                const Text(
                  'Gastos',
                  style: TextStyle(
                    fontFamily: 'SEGOE_UI',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
                const SizedBox(height: 12),
                ...expensesByCategory.entries.map(
                  (entry) => _CategoryRow(
                    category: entry.key,
                    amount: entry.value,
                    color: Colors.red,
                  ),
                ),
              ],

              // Ingresos por categoría
              if (incomesByCategory.isNotEmpty) ...[
                const SizedBox(height: 20),
                const Divider(thickness: 1.5),
                const SizedBox(height: 16),
                const Text(
                  'Ingresos',
                  style: TextStyle(
                    fontFamily: 'SEGOE_UI',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                ),
                const SizedBox(height: 12),
                ...incomesByCategory.entries.map(
                  (entry) => _CategoryRow(
                    category: entry.key,
                    amount: entry.value,
                    color: Colors.green,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const _TotalCard({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'SEGOE_UI',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    amount.toStringAsFixed(2),
                    style: TextStyle(
                      fontFamily: 'SEGOE_UI',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.euro_rounded, color: color, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final String category;
  final double amount;
  final Color color;

  const _CategoryRow({
    required this.category,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "- $category",
                    style: const TextStyle(
                      fontFamily: 'SEGOE_UI',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                amount.toStringAsFixed(2),
                style: TextStyle(
                  fontFamily: 'SEGOE_UI',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Icon(Icons.euro_rounded, color: color, size: 15),
            ],
          ),
        ],
      ),
    );
  }
}
