import 'package:uuid/uuid.dart';

const Uuid _uuid = Uuid();

enum Category { food, travel, leisure, work }

class Expense {
  final String id;
  final String title;
  final double amount;
  final DateTime date;

  final Category category;

  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = _uuid.v4();
}
