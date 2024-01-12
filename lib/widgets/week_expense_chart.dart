import 'package:expense_app/charts/expense_week_bar_graph.dart';
import 'package:expense_app/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeekExpenseChart extends StatelessWidget {
  const WeekExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseProvider>(
      builder: (context,value,child){
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          height: 210,
          child: const ExpenseWeekBarGraph(),
        );
      },);
  }
}