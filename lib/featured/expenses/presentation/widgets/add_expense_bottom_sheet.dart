import 'package:flutter/material.dart';
import 'package:track_expenses/core/constant/expenses_category.dart';
import 'package:track_expenses/core/themes/app_color.dart';
import 'package:track_expenses/featured/expenses/domain/entity/expense.dart';

class AddExpenseBottomSheet extends StatefulWidget {
  final Future<void> Function({
    required String name,
    required String category,
    required String amount,
    required TransactionType type,
  })
  onSave;

  const AddExpenseBottomSheet({super.key, required this.onSave});

  @override
  State<AddExpenseBottomSheet> createState() => AddExpenseBottomSheetState();
}

class AddExpenseBottomSheetState extends State<AddExpenseBottomSheet> {
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  String category = "";
  TransactionType type = TransactionType.expense;

  @override
  void initState() {
    super.initState();
    category = ExpensesCategory.expenseCategory[0];
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: AppColor.background,
        border: Border.all(color: AppColor.primary, width: 3),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 24.0,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
                    // Resetear categoría al cambiar de tipo
                    category = type == TransactionType.expense
                        ? ExpensesCategory.expenseCategory[0]
                        : ExpensesCategory.incomeCategory[0];
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
                    leadingIcon: Icon(Icons.arrow_downward, color: Colors.red),
                  ),
                  DropdownMenuEntry(
                    value: TransactionType.income,
                    label: "Ingreso",
                    leadingIcon: Icon(Icons.arrow_upward, color: Colors.green),
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
                style: const TextStyle(fontFamily: "SEGOE_UI", fontSize: 16),
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
              DropdownMenu<String>(
                onSelected: (String? value) {
                  setState(() {
                    category = value!;
                  });
                },
                initialSelection: category,
                width: MediaQuery.of(context).size.width - 48,
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
                dropdownMenuEntries:
                    (type == TransactionType.expense
                            ? ExpensesCategory.expenseCategory
                            : ExpensesCategory.incomeCategory)
                        .map(
                          (category) => DropdownMenuEntry(
                            value: category,
                            label: category,
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 20),

              // Monto
              const Text(
                "Cantidad",
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
                style: const TextStyle(fontFamily: "SEGOE_UI", fontSize: 16),
              ),
              const SizedBox(height: 30),

              // Botón de guardar
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSave(
                      name: nameController.text,
                      category: category,
                      amount: amountController.text,
                      type: type,
                    );
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
      ),
    );
  }
}
