import 'package:expense_app/models/expense.dart';
import 'package:expense_app/widgets/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:expense_app/models/category.dart';
import 'package:expense_app/providers/expense_provider.dart';
import 'package:provider/provider.dart';

class CategoryExpensesPage extends StatelessWidget {
  final ExpenseCategory category;
  final List<Expense> expenseList;

  const CategoryExpensesPage({Key? key, required this.category, required this.expenseList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final expensesForCategory =
        expenseProvider.getExpensesForCategory(category, expenseList);

    return Scaffold(
      appBar: AppBar(
        title: Text('${category.displayName} Expenses'),
      ),
      body: ExpenseList(expenses: expensesForCategory)
    );
  }
}
