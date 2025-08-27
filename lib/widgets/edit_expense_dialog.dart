import 'package:expense_app/models/category.dart';
import 'package:expense_app/models/expense.dart';
import 'package:expense_app/models/payment_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';

class EditExpenseDialog extends ConsumerStatefulWidget {
  final Expense expense;

  const EditExpenseDialog({super.key, required this.expense});

  @override
  _EditExpenseDialogState createState() => _EditExpenseDialogState();

  static Future<void> show(BuildContext context, Expense expense) async {
    await showDialog(
      context: context,
      builder: (context) => EditExpenseDialog(expense: expense),
    );
  }
}

class _EditExpenseDialogState extends ConsumerState<EditExpenseDialog> {
  late TextEditingController titleController;
  late TextEditingController amountController;
  late ExpenseCategory selectedCategory;
  final List<ExpenseCategory> categories = ExpenseCategory.values;
  late PaymentType selectedPaymentType;
  final List<PaymentType> paymentTypes = PaymentType.values;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.expense.note);
    amountController = TextEditingController(text: widget.expense.amount.toString());
    selectedCategory = widget.expense.category;
    selectedPaymentType = widget.expense.paymentType;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey.shade100,
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
            
            Expense updatedExpense = Expense(
              id: widget.expense.id,
              amount: amount,
              category: selectedCategory,
              dateTime: widget.expense.dateTime,
              note: title,
              paymentType: selectedPaymentType
            );
            
            try {
              await ref.read(expenseActionsProvider).editExpense(widget.expense, updatedExpense);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Expense updated successfully!"),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error updating expense: $e"),
                ),
              );
            }
          },
          child: Text(
            "Update", 
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
    super.dispose();
  }
}