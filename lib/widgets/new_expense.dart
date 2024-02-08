import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:expense_tracker/models/expense.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  final void Function({required Expense expense}) addNewExpense;

  const NewExpense({super.key, required this.addNewExpense});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime? _selectedDate;
  Category? _selectedCategory;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month - 1, now.day);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _changeCategory(Category? category) {
    if (category == null) return;

    setState(() {
      _selectedCategory = category;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('Invalid input'),
              content: const Text('Please, make sure all fields was entered.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'))
              ],
            );
          });
    } else {
      showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Invalid input'),
            content: const Text('Please, make sure all fields was entered.'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'))
            ],
          );
        },
      );
    }
  }

  void _submitForm() {
    // get all data
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text);
    final category = _selectedCategory;
    final date = _selectedDate;

    // check validation
    bool isValid = true;
    isValid = isValid && title.isNotEmpty;
    isValid = isValid && amount != null && amount > 0;
    isValid = isValid && category != null;
    isValid = isValid && date != null;

    if (!isValid) {
      _showDialog();
      return;
    }

    // hydrate data
    final newExpense = Expense(
      title: title,
      amount: amount,
      date: date,
      category: category,
    );

    // send data
    widget.addNewExpense(expense: newExpense);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return LayoutBuilder(builder: (context, constraints) {
      final double widgetWidth = constraints.maxWidth;

      return AnnotatedRegion<SystemUiOverlayStyle>(
        value:
            isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                children: [
                  if (widgetWidth >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _titleController,
                            maxLength: 50,
                            decoration: const InputDecoration(
                              labelText: 'Some Text',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 24,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                              prefixText: '\$',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    )
                  else
                    TextField(
                      controller: _titleController,
                      maxLength: 50,
                      decoration: const InputDecoration(
                        labelText: 'Some Text',
                      ),
                    ),
                  if (widgetWidth >= 600)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DropdownButton<Category>(
                            isExpanded: true,
                            hint: const Text('Category'),
                            value: _selectedCategory,
                            items: categoryIcons.entries
                                .map((entry) => DropdownMenuItem(
                                    value: entry.key,
                                    child: Row(
                                      children: [
                                        Icon(entry.value),
                                        const SizedBox(width: 10),
                                        Text(entry.key.name)
                                      ],
                                    )))
                                .toList(),
                            onChanged: _changeCategory,
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(_selectedDate == null
                                  ? 'No Date selected'
                                  : formatter.format(_selectedDate!)),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                              prefixText: '\$',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(_selectedDate == null
                                  ? 'No Date selected'
                                  : formatter.format(_selectedDate!)),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(Icons.calendar_month),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  const SizedBox(height: 20),
                  if (widgetWidth >= 600)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                            onPressed: _submitForm,
                            child: const Text('Save Expense'))
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<Category>(
                          hint: const Text('Category'),
                          value: _selectedCategory,
                          items: categoryIcons.entries
                              .map((entry) => DropdownMenuItem(
                                  value: entry.key,
                                  child: Row(
                                    children: [
                                      Icon(entry.value),
                                      const SizedBox(width: 10),
                                      Text(entry.key.name)
                                    ],
                                  )))
                              .toList(),
                          onChanged: _changeCategory,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                            onPressed: _submitForm,
                            child: const Text('Save Expense'))
                      ],
                    )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
