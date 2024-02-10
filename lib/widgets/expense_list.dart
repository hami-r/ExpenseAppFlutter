import 'package:expense_app/models/expense.dart';
import 'package:expense_app/providers/expense_provider.dart';
import 'package:expense_app/utils/category_utils.dart';
import 'package:expense_app/widgets/confirmation_dialog.dart';
import 'package:expense_app/widgets/edit_expense_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ExpenseList extends StatefulWidget {
  final List<Expense> expenses;

  const ExpenseList({Key? key, required this.expenses}) : super(key: key);

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final expenseLength = widget.expenses.length;
    return Expanded(
      child: ListView.builder(
        itemCount: expenseLength,
        itemBuilder: (context, index) {
          final expense = widget.expenses[expenseLength - index - 1];
          var slidableAction = SlidableAction(
            icon: Icons.delete,
            backgroundColor: Colors.red,
            onPressed: (context) =>
                {deleteDialog(context, expenseProvider, expense)},
          );
          return Slidable(
            endActionPane: ActionPane(motion: const StretchMotion(), children: [
              slidableAction,
              SlidableAction(
                icon: Icons.edit,
                backgroundColor: Colors.blue,
                onPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (context) => EditExpenseDialog(expense: expense),
                  );
                },
              ),
            ]),
            child: ListTile(
              leading: Icon(CategoryUtils.getIconForCategory(expense.category)),
              title: Text(expense.note.toString()),
              subtitle: Text(expense.formatDateTime()),
              trailing: Text(
                "₹${expense.amount}",
                style: TextStyle(fontSize: 15),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> deleteDialog(
      BuildContext context, ExpenseProvider expenseProvider, Expense expense) {
    return showDialog(
        context: context,
        builder: (context) {
          return ConfirmationDialog(
              title: "Delete this?",
              content: "Confirm",
              confirmButtonText: "Delete",
              cancelButtonText: "Cancel",
              onConfirm: () {
                expenseProvider.removeExpense(expense);
                Navigator.of(context).pop();
              },
              onCancel: () => Navigator.of(context).pop());
        });
  }
}
