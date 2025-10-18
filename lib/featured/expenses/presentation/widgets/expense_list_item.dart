import 'package:flutter/material.dart';
import 'package:track_expenses/core/themes/app_color.dart';
import 'package:track_expenses/featured/expenses/domain/entity/expense.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;

  const ExpenseListItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
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
              _DateRow(date: expense.date),
              const SizedBox(height: 8),
              _CategoryChip(category: expense.category),
            ],
          ),
          const SizedBox(width: 16),
          // Columna derecha: Nombre y Precio
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                _AmountText(amount: expense.amount, type: expense.type),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final DateTime date;

  const _DateRow({required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(
          '${date.day}/${date.month}/${date.year}',
          style: TextStyle(
            fontFamily: 'SEGOE_UI',
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String category;

  const _CategoryChip({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.secondary.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        category,
        style: const TextStyle(
          fontFamily: "SEGOE_UI",
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _AmountText extends StatelessWidget {
  final double amount;
  final TransactionType type;

  const _AmountText({required this.amount, required this.type});

  @override
  Widget build(BuildContext context) {
    final isExpense = type == TransactionType.expense;
    return Text(
      isExpense
          ? "- \$${amount.toStringAsFixed(2)}"
          : "\$${amount.toStringAsFixed(2)}",
      style: const TextStyle(
        fontFamily: "SEGOE_UI",
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColor.primary,
      ),
    );
  }
}
