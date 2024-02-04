import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_tile.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> registeredExpenses;

  const ExpensesList({super.key, required this.registeredExpenses});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: registeredExpenses.length,
      itemBuilder: (context, index) =>
          ExpenseTile(expense: registeredExpenses[index]),
    );
  }
}
