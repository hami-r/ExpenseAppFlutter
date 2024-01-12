import 'package:expense_app/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:provider/provider.dart';

class ExpenseHeatmapCalendar extends StatefulWidget {
  const ExpenseHeatmapCalendar({super.key});

  @override
  State<ExpenseHeatmapCalendar> createState() => _ExpenseHeatmapCalendarState();
}

class _ExpenseHeatmapCalendarState extends State<ExpenseHeatmapCalendar> {
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    return HeatMapCalendar(
      defaultColor: const Color.fromARGB(255, 105, 183, 151),
      borderRadius: 1,
      flexible: true, 
      colorMode: ColorMode.color,
      fontSize: 20,
      monthFontSize: 20,
      weekTextColor: Colors.grey[700],
      textColor: Colors.white,
      showColorTip: false,
      datasets: expenseProvider.expenseMonthHeatmap(date),
      colorsets: {
        1: Colors.green.shade100,
        2: Colors.green.shade200,
        3: Colors.green.shade300,
        4: Colors.green.shade400,
        5: Colors.green.shade500,
        6: Colors.green.shade600,
        7: Colors.green.shade700,
        8: Colors.green.shade800,
      },
      onClick: (value) {
        expenseProvider.getExpenseByDate(value);
      },
      onMonthChange: (value){
        setState(() {
          date = value;
        });
      },
    );
  }
}
