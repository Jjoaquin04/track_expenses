import 'package:flutter/material.dart';
import 'package:track_expenses/core/themes/app_color.dart';
import 'package:track_expenses/featured/expenses/domain/entity/expense.dart';
import 'package:track_expenses/l10n/app_localizations.dart';

class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback? onLongPress;
  final VoidCallback? onTap;
  final bool isSelectionMode;
  final bool isSelected;

  const ExpenseListItem({
    super.key,
    required this.expense,
    this.onLongPress,
    this.onTap,
    this.isSelectionMode = false,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isSelectionMode) ...[
              Checkbox(
                value: isSelected,
                onChanged: (value) {
                  if (onTap != null) onTap!();
                },
                activeColor: AppColor.primary,
              ),
              const SizedBox(width: 12),
            ],
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
                  Row(
                    children: [
                      Text(
                        expense.nameExpense,
                        style: const TextStyle(
                          fontFamily: "SEGOE_UI",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                      ),
                      if (expense.fixedExpense == 1) ...[
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: BorderSide(
                                      color: AppColor.primary,
                                      width: 2.0,
                                    ),
                                  ),
                                  title: Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline_rounded,
                                        size: 30,
                                        color: AppColor.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          l10n.fixedTransactionInfo,
                                          style: const TextStyle(
                                            fontFamily: "SEGOE_UI",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 12),
                                      Text(
                                        l10n.fixedTransactionDescription,
                                        style: const TextStyle(
                                          fontFamily: "SEGOE_UI",
                                          fontSize: 18,
                                          color: Colors.black87,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: const Icon(
                            Icons.push_pin,
                            size: 16,
                            color: AppColor.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  _AmountText(amount: expense.amount, type: expense.type),
                ],
              ),
            ),
          ],
        ),
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
    return Row(
      children: [
        Text(
          isExpense
              ? "-${amount.toStringAsFixed(2)}"
              : "\$${amount.toStringAsFixed(2)}",
          style: const TextStyle(
            fontFamily: "SEGOE_UI",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColor.primary,
          ),
        ),
        Icon(Icons.euro_rounded, color: AppColor.primary, size: 18),
      ],
    );
  }
}
