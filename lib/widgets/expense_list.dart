import 'package:expense_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_app/models/category.dart';

class ExpenseList extends StatefulWidget {
  final List<Expense> expenses;

  const ExpenseList({Key? key, required this.expenses}) : super(key: key);

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  @override
  Widget build(BuildContext context) {
    final expenseLength = widget.expenses.length;
    return Expanded(
      child: ListView.builder(
        itemCount: expenseLength,
        itemBuilder: (context, index) {
          final expense = widget.expenses[expenseLength-index-1];
          return ListTile(
            leading: Icon(getIconForCategory(expense.category)),
            title: Text(expense.note.toString()),
            subtitle: Text(expense.formatDateTime()),
            trailing: Text(
              "₹${expense.amount}",
              style: const TextStyle(fontSize: 15),
            ),
          );
        },
      ),
    );
  }

  IconData getIconForCategory(Category category) {
    switch (category) {
      case Category.food:
        return Icons.fastfood;
      case Category.shopping:
        return Icons.shopping_cart;
      case Category.bills:
        return Icons.receipt;
      case Category.eatingOut:
        return Icons.restaurant;
      case Category.casualSpent:
        return Icons.attach_money;
      case Category.others:
        return Icons.category;
    }
  }
}
