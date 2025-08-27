import 'package:expense_app/models/expense.dart';
import 'package:expense_app/widgets/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:expense_app/models/category.dart';
import 'package:expense_app/providers/expense_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryExpensesPage extends ConsumerWidget {
  final ExpenseCategory category;
  final List<Expense> expenseList;

  const CategoryExpensesPage({
    super.key, 
    required this.category, 
    required this.expenseList
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(expenseActionsProvider);
    final expensesForCategory = actions.getExpensesForCategory(category, expenseList);

    return Scaffold(
      appBar: AppBar(
        title: Text('${category.displayName} Expenses'),
      ),
      body: Column(
        children: [
          ExpenseList(expenses: expensesForCategory),
        ],
      ),
    );
  }
}