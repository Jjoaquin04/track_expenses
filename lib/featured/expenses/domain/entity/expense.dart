import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String? id;
  final String ownerExpense;
  final String nameExpense;
  final double amount;
  final String category;
  final DateTime date;

  const Expense({
    this.id,
    required this.ownerExpense,
    required this.nameExpense,
    required this.amount,
    required this.category,
    required this.date,
  });

  @override
  List<Object?> get props => [
    id,
    ownerExpense,
    nameExpense,
    amount,
    category,
    date,
  ];
}
