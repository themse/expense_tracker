import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Learn Flutter',
      amount: 10.50,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _openAddExpenseModal() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return NewExpense(
            addNewExpense: _addExpense,
          );
        });
  }

  void _addExpense({required Expense expense}) {
    setState(() {
      _registeredExpenses.insert(0, expense);
    });
    Navigator.pop(context);
  }

  void _removeExpense({required Expense expense}) {
    final int expenseIndex = _registeredExpenses.indexOf(expense);

    setState(() {
      _registeredExpenses.remove(expense);
    });

    // Undo
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Flutter ExpenseTracker"),
        actions: [
          IconButton(
            onPressed: _openAddExpenseModal,
            icon: const Icon(Icons.add),
            color: Colors.white,
            iconSize: 35,
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: screenWidth < 600
            ? Column(
                children: [
                  Chart(expenses: _registeredExpenses),
                  Expanded(
                    child: ExpensesList(
                        registeredExpenses: _registeredExpenses,
                        removeExpense: _removeExpense),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(child: Chart(expenses: _registeredExpenses)),
                  Expanded(
                    child: ExpensesList(
                        registeredExpenses: _registeredExpenses,
                        removeExpense: _removeExpense),
                  ),
                ],
              ),
      ),
    );
  }
}
