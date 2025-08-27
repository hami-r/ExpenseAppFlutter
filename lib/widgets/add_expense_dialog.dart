import 'package:expense_app/models/category.dart';
import 'package:expense_app/models/expense.dart';
import 'package:expense_app/models/payment_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';

class AddExpenseDialog extends ConsumerStatefulWidget {
  const AddExpenseDialog({super.key});

  @override
  _AddExpenseDialogState createState() => _AddExpenseDialogState();

  static Future<void> show(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => const AddExpenseDialog(),
    );
  }
}

class _AddExpenseDialogState extends ConsumerState<AddExpenseDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  ExpenseCategory selectedCategory = ExpenseCategory.food;
  final List<ExpenseCategory> categories = ExpenseCategory.values;
  PaymentType selectedPaymentType = PaymentType.cash;
  final List<PaymentType> paymentTypes = PaymentType.values;

  @override
  Widget build(BuildContext context) {
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
            initialValue: selectedCategory,
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
          ),
          DropdownButtonFormField(
            initialValue: selectedPaymentType,
            items: paymentTypes.map((PaymentType type) {
              return DropdownMenuItem<PaymentType>(
                value: type,
                child: Text(PaymentTypeUtils.toStringValue(type)),
              );
            }).toList(),
            onChanged: (PaymentType? value) {
              if (value != null) {
                setState(() {
                  selectedPaymentType = value;
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.grey.shade900),
          ),
        ),
        TextButton(
          onPressed: () async {
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
            if (amount == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Please enter a valid amount."),
                ),
              );
              return;
            }

            DateTime currentDate = DateTime.now();
            Expense expense = Expense(
              amount: amount,
              category: selectedCategory,
              dateTime: currentDate,
              note: title,
              paymentType: selectedPaymentType,
            );

            try {
              await ref.read(expenseActionsProvider).addExpense(expense);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Expense added successfully!"),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error adding expense: $e"),
                ),
              );
            }
          },
          child: Text(
            "Save",
            style: TextStyle(color: Colors.grey.shade900),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    categoryController.dispose();
    super.dispose();
  }
}
