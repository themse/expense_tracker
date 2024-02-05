import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/expenses_list/expenses_list_empty.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_tile.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> registeredExpenses;
  final void Function({required Expense expense}) removeExpense;

  const ExpensesList({
    super.key,
    required this.registeredExpenses,
    required this.removeExpense,
  });

  @override
  Widget build(BuildContext context) {
    if (registeredExpenses.isEmpty) {
      return const ExpensesListEmpty();
    }

    return ListView.builder(
      itemCount: registeredExpenses.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(registeredExpenses[index]),
        onDismissed: (direction) =>
            removeExpense(expense: registeredExpenses[index]),
        child: ExpenseTile(expense: registeredExpenses[index]),
      ),
    );
  }
}
