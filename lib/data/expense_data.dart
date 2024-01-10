import 'package:expense_app/models/category.dart';
import 'package:expense_app/models/expense.dart';

List<Expense> sampleExpenses = [
  Expense(
    amount: 10.0,
    category: Category.food,
    note: 'Lunch at a local restaurant',
    dateTime: DateTime(2024, 1, 1, 12, 0),
  ),
  Expense(
    amount: 25.0,
    category: Category.shopping,
    note: 'New pair of shoes',
    dateTime: DateTime(2023, 12, 30, 18, 30),
  ),
  Expense(
    amount: 30.0,
    category: Category.bills,
    note: 'Electricity bill for the month',
    dateTime: DateTime(2024, 1, 2, 8, 0),
  ),
  Expense(
    amount: 20.0,
    category: Category.eatingOut,
    note: 'Dinner with friends',
    dateTime: DateTime(2024, 1, 3, 20, 15),
  ),
  Expense(
    amount: 15.0,
    category: Category.casualSpent,
    note: 'Coffee and snacks',
    dateTime: DateTime(2024, 1, 4, 10, 45),
  ),
  Expense(
    amount: 40.0,
    category: Category.shopping,
    note: 'Clothing purchase',
    dateTime: DateTime(2024, 1, 5, 14, 30),
  ),
  Expense(
    amount: 500.0,
    category: Category.shopping,
    note: 'Grocery shopping',
    dateTime: DateTime(2024, 1, 6, 16, 0),
  ),
  Expense(
    amount: 5.0,
    category: Category.bills,
    note: 'Internet bill for the month',
    dateTime: DateTime(2024, 1, 7, 9, 45),
  ),
  Expense(
    amount: 28.0,
    category: Category.eatingOut,
    note: 'Lunch with colleagues',
    dateTime: DateTime(2024, 1, 8, 13, 20),
  ),
  Expense(
    amount: 25.0,
    category: Category.casualSpent,
    note: 'Movie night with family',
    dateTime: DateTime(2024, 1, 9, 19, 0),
  ),
];
