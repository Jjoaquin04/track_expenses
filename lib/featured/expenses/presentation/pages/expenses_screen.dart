import 'package:flutter/material.dart';
import 'package:track_expenses/core/themes/app_color.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => ExpensesScreenState();
}

class ExpensesScreenState extends State<ExpensesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: const Text(
            'Bienvenido usuario',
            style: TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
              fontFamily: 'SEGOE_UI',
              fontSize: 27,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                color: AppColor.primary,
                size: 30,
              ),
              onPressed: () {
                // Acción al presionar el botón de edición
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Text(
            'Seguimiento de gastos personales',
            style: TextStyle(fontSize: 35, color: AppColor.primary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
