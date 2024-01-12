import 'package:expense_app/charts/bar_data.dart';
import 'package:expense_app/providers/expense_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseWeekBarGraph extends StatelessWidget {

  const ExpenseWeekBarGraph({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final eachDayExpensesThisWeek = expenseProvider.getWeeklyExpenseMap().values.toList();
    final double maxExpense = eachDayExpensesThisWeek.reduce((value, element) => value > element ? value : element);
    final maxY = maxExpense * 1.1;
    BarData barData = BarData(dailyAmounts:eachDayExpensesThisWeek);
    final bars = barData.initializeBarData();
    return BarChart(BarChartData(
      maxY: maxY,
      minY: 0,
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: const FlTitlesData(
        show: true,
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: getBottomTitles ))
      ),
      barGroups: bars
          .map((data) => BarChartGroupData(
            x: data.x,
            barRods: [
                BarChartRodData(
                    toY: data.y,
                    color: Colors.grey[800],
                    width: 25,
                    borderRadius: BorderRadius.circular(4),
                    backDrawRodData: BackgroundBarChartRodData(
                        show: true, color: Colors.grey[200], toY: maxY))
            ]))
          .toList(),
    ));
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  var style = TextStyle(
    color: Colors.grey[800],
    fontWeight: FontWeight.bold,
  );

  Widget text;
  switch (value) {
    case 0:
      text = Text("S", style: style);
      break;
    case 1:
      text = Text("M", style: style);
      break;
    case 2:
      text = Text("T", style: style);
      break;
    case 3:
      text = Text("W", style: style);
      break;
    case 4:
      text = Text("T", style: style);
      break;
    case 5:
      text = Text("F", style: style);
      break;
    case 6:
      text = Text("S", style: style);
      break;
    default:
      text = const Text("");
      break;
  }

  return text;
}
