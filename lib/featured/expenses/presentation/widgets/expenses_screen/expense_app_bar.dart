import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostra/core/themes/app_color.dart';
import 'package:nostra/core/utils/user_config.dart';
import 'package:nostra/featured/expenses/domain/entity/expense.dart';
import 'package:nostra/featured/expenses/presentation/bloc/expense_bloc.dart';
import 'package:nostra/featured/expenses/presentation/bloc/expense_state.dart';
import 'package:nostra/featured/expenses/presentation/pages/language_settings_screen.dart';
import 'package:nostra/l10n/app_localizations.dart';

class ExpenseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ExpenseAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppBar(
      backgroundColor: AppColor.background,
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
                '${l10n.hello} $userName',
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
      actions: [
        const _TotalBalanceWidget(),
        IconButton(
          icon: const Icon(Icons.translate_rounded, color: AppColor.primary),
          tooltip: 'Idioma / Language',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LanguageSettingsScreen(),
              ),
            );
          },
        ),
      ],
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

            final l10n = AppLocalizations.of(context)!;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.total,
                  style: const TextStyle(
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
                    Icon(Icons.euro_rounded, color: AppColor.primary, size: 18),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
