import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_expenses/core/themes/app_color.dart';
import 'package:track_expenses/core/utils/user_config.dart';
import 'package:track_expenses/featured/expenses/domain/entity/expense.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_bloc.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_state.dart';

class ExpenseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ExpenseAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.background,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColor.primary, width: 2.5),
      ),
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
              const Icon(Icons.waving_hand_outlined, color: AppColor.primary),
            ],
          );
        },
      ),
      actions: const [_TotalBalanceWidget()],
    );
  }
}

class _TotalBalanceWidget extends StatelessWidget {
  const _TotalBalanceWidget();

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

        return FutureBuilder<double>(
          future: UserConfig.getInitialBalance(),
          builder: (context, balanceSnapshot) {
            final initialBalance = balanceSnapshot.data ?? 0.0;
            final currentBalance = initialBalance + totalIncome - totalExpenses;

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
                  Row(
                    children: [
                      Text(
                        currentBalance.toStringAsFixed(2),
                        style: const TextStyle(
                          fontFamily: "SEGOE_UI",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary,
                        ),
                      ),
                      Icon(
                        Icons.euro_rounded,
                        color: AppColor.primary,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
