import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_expenses/featured/expenses/domain/entity/expense.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_bloc.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_state.dart';

class SummaryCardsWidget extends StatelessWidget {
  const SummaryCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
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

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Text(
                "Seguimiento de Gastos Personales",
                style: TextStyle(
                  fontFamily: "SEGOE_UI",
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SummaryCard(
                    label: "Gastos",
                    amount: totalExpenses,
                    icon: Icons.arrow_downward,
                    color: Colors.red,
                    isExpense: true,
                  ),
                  _SummaryCard(
                    label: "Ingresos",
                    amount: totalIncome,
                    icon: Icons.arrow_upward,
                    color: Colors.green,
                    isExpense: false,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;
  final bool isExpense;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 100,
        margin: EdgeInsets.only(
          right: isExpense ? 8.0 : 0,
          left: isExpense ? 0 : 8.0,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: "SEGOE_UI",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "\$${amount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontFamily: "SEGOE_UI",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
