import 'package:expense_app/models/category.dart';
import 'package:expense_app/utils/category_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpensePieChart extends StatelessWidget {
  final Map<ExpenseCategory, double> categoryData;

  const ExpensePieChart(this.categoryData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (categoryData.entries.length == 1) { //because of bug, when there is only one category and selected a date which has more than two categories, piechart becomes black, still it only solved the bug partially and a new bug came
      categoryData.addAll({ExpenseCategory.circle:.000001});
    }
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sections: categoryData.isNotEmpty ?  categoryData.entries
                      .map((entry) =>
                          buildPieChartSection(entry.key, entry.value))
                      .toList() : [buildEmptySection(),buildEmptySection()],
              sectionsSpace: 3,
              centerSpaceRadius: 65,
              startDegreeOffset: 0,
            ),
            swapAnimationDuration: const Duration(seconds: 1),
            swapAnimationCurve: Curves.easeOutQuad,
          ),
          if (categoryData.isEmpty) buildNoDataMessage(),
        ],
      ),
    );
  }

  PieChartSectionData buildPieChartSection(ExpenseCategory category, double value) {
    return PieChartSectionData(
      color: getCategoryColor(category),
      value: value,
      title: "",
      radius: 33,
      badgeWidget: buildBadgeWidget(category),
      badgePositionPercentageOffset: 1.7,
      showTitle: false,
    );
  }

  PieChartSectionData buildEmptySection() {
    return PieChartSectionData(
      color: Colors.grey[500]!,
      value: 1,
      title: "",
      radius: 33,
      showTitle: false,
    );
  }

  Widget buildNoDataMessage() {
    return const Center(
      child: Text(
        'No data available',
        style: TextStyle(fontSize: 13, color: Colors.grey),
      ),
    );
  }

  Widget buildBadgeWidget(ExpenseCategory category) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: getCategoryColor(category),
      ),
      child: Icon(
        CategoryUtils.getIconForCategory(category),
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Color getCategoryColor(ExpenseCategory category) {
    switch (category) {
      case ExpenseCategory.food:
        return Colors.redAccent;
      case ExpenseCategory.shopping:
        return Colors.blueAccent;
      case ExpenseCategory.bills:
        return Colors.greenAccent;
      case ExpenseCategory.eatingOut:
        return Colors.orangeAccent;
      case ExpenseCategory.casualSpent:
        return Colors.purpleAccent;
      case ExpenseCategory.fuel:
        return Colors.limeAccent;
      case ExpenseCategory.others:
        return Colors.tealAccent;
      case ExpenseCategory.circle:
        return Colors.white;
      default:
        return Colors.pinkAccent;
    }
  }


  
}

