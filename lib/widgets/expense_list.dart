import 'package:expense_app/models/expense.dart';
import 'package:expense_app/models/payment_type.dart';
import 'package:expense_app/providers/expense_provider.dart';
import 'package:expense_app/utils/category_utils.dart';
import 'package:expense_app/widgets/confirmation_dialog.dart';
import 'package:expense_app/widgets/edit_expense_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseList extends ConsumerWidget {
  final List<Expense> expenses;

  const ExpenseList({Key? key, required this.expenses}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseLength = expenses.length;

    return Expanded(
      child: ListView.builder(
        itemCount: expenseLength,
        itemBuilder: (context, index) {
          final expense = expenses[expenseLength - index - 1];

          return Slidable(
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              children: [
                SlidableAction(
                  icon: Icons.delete,
                  backgroundColor: Colors.red,
                  onPressed: (context) => _deleteDialog(context, ref, expense),
                ),
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
              ],
            ),
            child: ListTile(
              leading: Icon(CategoryUtils.getIconForCategory(expense.category)),
              title: Text(expense.note ?? 'No description'),
              subtitle: Text(
                  "${expense.formatDateTime()} • ${PaymentTypeUtils.toStringValue(expense.paymentType)}"),
              trailing: Text(
                "₹${expense.amount}",
                style: const TextStyle(fontSize: 15),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> _deleteDialog(
      BuildContext context, WidgetRef ref, Expense expense) {
    return showDialog(
      context: context,
      builder: (context) {
        return ConfirmationDialog(
          title: "Delete this?",
          content: "Confirm",
          confirmButtonText: "Delete",
          cancelButtonText: "Cancel",
          onConfirm: () async {
            try {
              await ref.read(expenseActionsProvider).removeExpense(expense);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Expense deleted successfully!"),
                ),
              );
            } catch (e) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error deleting expense: $e"),
                ),
              );
            }
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
