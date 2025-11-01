import 'package:flutter/material.dart';
import 'package:track_expenses/core/constant/date_constants.dart';
import 'package:track_expenses/core/themes/app_color.dart';

class MonthCard extends StatelessWidget {
  final int month;
  final int year;
  final double totalExpenses;
  final double totalIncome;
  final Map<String, double> expensesByCategory;
  final Map<String, double> incomesByCategory;

  const MonthCard({
    super.key,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColor.primary, width: 2.5),
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
                  TotalCard(
                    label: 'Gastos',
                    amount: totalExpenses,
                    color: Colors.red,
                    icon: Icons.arrow_downward,
                  ),
                  TotalCard(
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
                  (entry) => CategoryRow(
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
                  (entry) => CategoryRow(
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

class TotalCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final IconData icon;

  const TotalCard({
    super.key,
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

class CategoryRow extends StatelessWidget {
  final String category;
  final double amount;
  final Color color;

  const CategoryRow({
    super.key,
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
