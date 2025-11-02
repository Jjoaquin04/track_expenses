import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:track_expenses/core/themes/app_color.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_bloc.dart';
import 'package:track_expenses/featured/expenses/presentation/bloc/expense_event.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const DeleteConfirmationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(color: AppColor.primary, width: 2.0),
      ),
      title: const Text(
        'Confirmar eliminación',
        style: TextStyle(fontFamily: 'SEGOE_UI', fontWeight: FontWeight.bold),
      ),
      content: const Text(
        '¿Estás seguro de que quieres eliminar los gastos seleccionados?',
        style: TextStyle(fontFamily: 'SEGOE_UI'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.grey, fontFamily: 'SEGOE_UI'),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.read<ExpenseBloc>().add(DeleteSelectedExpensesEvent());
          },
          child: const Text(
            'Eliminar',
            style: TextStyle(color: Colors.red, fontFamily: 'SEGOE_UI'),
          ),
        ),
      ],
    );
  }
}
