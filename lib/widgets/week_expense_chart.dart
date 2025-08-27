import 'package:expense_app/charts/barchart/expense_week_bar_graph.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WeekExpenseChart extends ConsumerWidget {
  const WeekExpenseChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      height: 210,
      child: const ExpenseWeekBarGraph(),
    );
  }
}