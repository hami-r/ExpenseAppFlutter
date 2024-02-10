import 'package:expense_app/models/category.dart';
import 'package:expense_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';

class EditExpenseDialog extends StatefulWidget {
  final Expense expense;

  const EditExpenseDialog({Key? key, required this.expense}) : super(key: key);

  @override
  _EditExpenseDialogState createState() => _EditExpenseDialogState();

  static Future<void> show(BuildContext context, Expense expense) async {
    await showDialog(
      context: context,
      builder: (context) => EditExpenseDialog(expense: expense),
    );
  }
}

class _EditExpenseDialogState extends State<EditExpenseDialog> {
  late TextEditingController titleController;
  late TextEditingController amountController;
  late ExpenseCategory selectedCategory;
  final List<ExpenseCategory> categories = ExpenseCategory.values;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.expense.note);
    amountController = TextEditingController(text: widget.expense.amount.toString());
    selectedCategory = widget.expense.category;
  }

  @override
  Widget build(BuildContext context) {
    var expenseProvider = Provider.of<ExpenseProvider>(context);

    return AlertDialog(
      title: const Text("Edit Expense"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: "Title"),
          ),
          TextField(
            controller: amountController,
            decoration: const InputDecoration(labelText: "Amount"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          DropdownButtonFormField(
            value: selectedCategory,
            items: categories.map((ExpenseCategory category) {
              return DropdownMenuItem<ExpenseCategory>(
                value: category,
                child: Text(category.displayName),
              );
            }).toList(),
            onChanged: (ExpenseCategory? value) {
              debugPrint(value.toString());
              if (value != null) {
                setState(() {
                  selectedCategory = value;
                });
              }
            },
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            String title = titleController.text.trim();
            String amountText = amountController.text.trim();
            if (title.isEmpty || amountText.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Title and amount are required."),
                ),
              );
              return;
            }
            double? amount = double.tryParse(amountText);
            Expense updatedExpense = Expense(
              id: widget.expense.id,
              amount: amount,
              category: selectedCategory,
              dateTime: widget.expense.dateTime,
              note: title,
            );
            expenseProvider.editExpense(widget.expense, updatedExpense);
            Navigator.of(context).pop();
          },
          child: const Text("Update"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }
}
