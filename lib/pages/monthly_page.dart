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
    final monthsExpense = expenseProvider.calculateExpenseOfSelectedMonth();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Calendar"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const ExpenseHeatmapCalendar(),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Month's Total: ₹$monthsExpense",style: const TextStyle(fontSize: 15),),
                  Text("Total: ₹$totalExpense",style: const TextStyle(fontSize: 15),),
                ],
              ),
              const SizedBox(height: 10,),
              ExpenseList(expenses: expenseProvider.expensesByDate)
            ],
          ),
        ),
      ),
    );
  }
}