import 'package:flutter/material.dart';

import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expense_chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter course',
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: 'United States',
      amount: 9.99,
      date: DateTime.now(),
      category: Category.travel,
    ),
    Expense(
      title: 'Cinema',
      amount: 10.5,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: 'Cheese Macroni',
      amount: 2.5,
      date: DateTime.now(),
      category: Category.food,
    ),
  ];

  void _addNewExpense() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return NewExpense(
            addNewExpense: ({required Expense expense}) {
              setState(() {
                _registeredExpenses.insert(0, expense);
              });

              Navigator.pop(context);
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        title: const Text("Flutter ExpenseTracker"),
        actions: [
          IconButton(
            onPressed: _addNewExpense,
            icon: const Icon(Icons.add),
            color: Colors.white,
            iconSize: 35,
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              width: double.infinity,
              child: ExpenseChart(),
            ),
            Expanded(
              child: ExpensesList(registeredExpenses: _registeredExpenses),
            ),
          ],
        ),
      ),
    );
  }
}
