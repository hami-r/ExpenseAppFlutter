import 'package:expense_app/models/category.dart';
import 'package:expense_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/expense_provider.dart';

class AddExpenseDialog extends StatefulWidget {
  const AddExpenseDialog({Key? key}) : super(key: key);

  @override
  _AddExpenseDialogState createState() => _AddExpenseDialogState();

  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const AddExpenseDialog(),
    );
  }
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  ExpenseCategory selectedCategory = ExpenseCategory.food;
  List<ExpenseCategory> categories = ExpenseCategory.values;
  @override
  Widget build(BuildContext context) {
    var expenseProvider = Provider.of<ExpenseProvider>(context);

    return AlertDialog(
      backgroundColor: Colors.grey.shade100,
      title: const Text("Add Expense"),
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
              })
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel", style: TextStyle(color: Colors.grey.shade900),),
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
            DateTime currentDate = DateTime.now();
            Expense expense = Expense(
                amount: amount,
                category: selectedCategory,
                dateTime: currentDate,
                note: title);
            expenseProvider.addExpense(expense);
            expenseProvider.calculateExpenseOfToday();
            expenseProvider.getExpenseByDate(null);
            expenseProvider.calculateExpenseOfSelectedDate();
            expenseProvider.getExpensesOfMonth(null);
            Navigator.of(context).pop();
          },
          child: Text("Save",style: TextStyle(color: Colors.grey.shade900),),
        ),
      ],
    );
  }
}
