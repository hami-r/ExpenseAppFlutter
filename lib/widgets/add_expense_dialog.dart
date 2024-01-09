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
      builder: (context) => AddExpenseDialog(),
    );
  }
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  Category selectedCategory = Category.food;
  List<Category> categories = Category.values;
  @override
  Widget build(BuildContext context) {
    var expenseProvider = Provider.of<ExpenseProvider>(context);

    return AlertDialog(
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
              items: categories.map((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.toString().split('.').last),
                );
              }).toList(),
              onChanged: (Category? value) {
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
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            String title = titleController.text.trim();
            double? amount = double.tryParse(amountController.text.trim());
            DateTime currentDate = DateTime.now();
            Expense expense = Expense(
                amount: amount,
                category: selectedCategory,
                dateTime: currentDate,
                note: title);
            expenseProvider.addExpense(expense);
            expenseProvider.calculateExpenseOfToday();
            Navigator.of(context).pop();
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
