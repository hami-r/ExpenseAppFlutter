import 'package:expense_app/models/category.dart';
import 'package:expense_app/utils/category_utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ExpensePieChart extends StatelessWidget {
  final Map<ExpenseCategory, double> categoryData;

  const ExpensePieChart(this.categoryData, {super.key});

  @override
  Widget build(BuildContext context) {
    print("categoryData: $categoryData");
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sections: categoryData.isNotEmpty ?  categoryData.entries
                      .map((entry) =>
                          buildPieChartSection(entry.key, entry.value))
                      .toList() : [buildEmptySection()],
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
  final safeValue = value > 0 ? value : 0.0001;

  return PieChartSectionData(
    color: CategoryUtils.getCategoryColor(category),
    value: safeValue,
    title: "",
    radius: 33,
    badgeWidget: value > 0 ? buildBadgeWidget(category) : null,
    badgePositionPercentageOffset: 1.0, // try smaller than 1.7
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
      badgeWidget: null,
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
  return SizedBox(
    width: 28,
    height: 28,
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: CategoryUtils.getCategoryColor(category),
      ),
      child: Icon(
        CategoryUtils.getIconForCategory(category),
        color: Colors.white,
        size: 16,
      ),
    ),
  );
}

  
}

