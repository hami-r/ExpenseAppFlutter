import 'package:expense_app/providers/expense_provider.dart';
import 'package:expense_app/widgets/expense_heatmap_calender.dart';
import 'package:expense_app/widgets/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyPage extends StatefulWidget {
  const MonthlyPage({super.key});

  @override
  State<MonthlyPage> createState() => _MonthlyPageState();
}

class _MonthlyPageState extends State<MonthlyPage> {
  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final totalExpense = expenseProvider.calculateExpenseOfSelectedDate();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
            const ExpenseHeatmapCalendar(),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:8.0),
              child: Text("Total: ₹$totalExpense",style: const TextStyle(fontSize: 17),),
            ),
            const SizedBox(height: 10,),
            ExpenseList(expenses: expenseProvider.expensesByDate)
          ],
        ),
      ),
    );
  }
}