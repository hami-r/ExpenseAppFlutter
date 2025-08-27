import 'package:expense_app/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpenseHeatmapCalendar extends ConsumerStatefulWidget {
  const ExpenseHeatmapCalendar({super.key});

  @override
  ConsumerState<ExpenseHeatmapCalendar> createState() => _ExpenseHeatmapCalendarState();
}

class _ExpenseHeatmapCalendarState extends ConsumerState<ExpenseHeatmapCalendar> {
  DateTime date = DateTime.now();
  
  @override
  Widget build(BuildContext context) {
    final heatmapData = ref.watch(expenseHeatmapProvider(date));
    
    return HeatMapCalendar(
      defaultColor: const Color.fromARGB(255, 130, 240, 138),
      borderRadius: 1,
      flexible: true, 
      colorMode: ColorMode.color,
      fontSize: 20,
      monthFontSize: 20,
      weekTextColor: Colors.grey[700],
      textColor: Colors.white,
      showColorTip: false,
      datasets: heatmapData,
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
        // Update selected date in the provider
        ref.read(expenseActionsProvider).setSelectedDate(value);
      },
      onMonthChange: (value) {
        setState(() {
          date = value;
        });
        // Update selected month in the provider
        ref.read(expenseActionsProvider).setSelectedMonth(value);
      },
    );
  }
}