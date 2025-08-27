import 'package:expense_app/models/category.dart';
import 'package:expense_app/models/expense.dart';
import 'package:expense_app/pages/category_expense_page.dart';
import 'package:expense_app/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/charts/piechart/expense_piechart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_app/utils/category_utils.dart';

// State providers for date range selection
final summaryStartDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final summaryEndDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

// Provider for expenses within selected date range
final summaryExpensesProvider = Provider<List<Expense>>((ref) {
  final startDate = ref.watch(summaryStartDateProvider);
  final endDate = ref.watch(summaryEndDateProvider);
  final expensesAsync = ref.watch(expensesStreamProvider);
  
  return expensesAsync.when(
    data: (expenses) {
      final actions = ref.read(expenseActionsProvider);
      return actions.getExpensesByDateRange(expenses, startDate, endDate);
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Provider for category map
final summaryCategoryMapProvider = Provider<Map<ExpenseCategory, double>>((ref) {
  final selectedExpenses = ref.watch(summaryExpensesProvider);
  final actions = ref.read(expenseActionsProvider);
  return actions.mapExpensesToCategories(selectedExpenses);
});

// Provider for category list (sorted by percentage)
final summaryCategoryListProvider = Provider<List<MapEntry<ExpenseCategory, double>>>((ref) {
  final categoryMap = ref.watch(summaryCategoryMapProvider);
  final categoryList = categoryMap.entries.toList();
  
  final totalAmount = categoryList.fold(0.0, (sum, entry) => sum + entry.value);
  
  // Sort by percentage (descending)
  categoryList.sort((a, b) {
    if (totalAmount == 0) return 0;
    double percentageA = (a.value / totalAmount) * 100;
    double percentageB = (b.value / totalAmount) * 100;
    return percentageB.compareTo(percentageA);
  });
  
  return categoryList;
});

// Provider for total amount
final summaryTotalAmountProvider = Provider<double>((ref) {
  final categoryList = ref.watch(summaryCategoryListProvider);
  return categoryList.fold(0.0, (sum, entry) => sum + entry.value);
});

class SummaryPage extends ConsumerWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startDate = ref.watch(summaryStartDateProvider);
    final endDate = ref.watch(summaryEndDateProvider);
    final selectedExpenses = ref.watch(summaryExpensesProvider);
    final categoryList = ref.watch(summaryCategoryListProvider);
    final categoryMap = ref.watch(summaryCategoryMapProvider);
    final totalAmount = ref.watch(summaryTotalAmountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Summary"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    DateTimeRange? selectedDates = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      saveText: "Confirm"
                    );
                    if (selectedDates != null) {
                      ref.read(summaryStartDateProvider.notifier).state = selectedDates.start;
                      ref.read(summaryEndDateProvider.notifier).state = selectedDates.end;
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                  tooltip: 'Pick a date',
                ),
                const SizedBox(width: 8),
                Text(
                  "${DateFormat('dd/MM/yy').format(startDate)} - ${DateFormat('dd/MM/yy').format(endDate)}",
                  style: const TextStyle(fontSize: 17, color: Colors.black),
                ),
              ],
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Total Amount:   ',
                    style: TextStyle(fontSize: 17, color: Colors.black),
                  ),
                  TextSpan(
                    text: '₹$totalAmount',
                    style: TextStyle(
                        fontSize: 25, color: Colors.greenAccent.shade700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 55),
            SizedBox(
              height: 200,
              width: 200,
              child: ExpensePieChart(categoryMap),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  double percentage = totalAmount > 0 
                      ? (categoryList[index].value / totalAmount) * 100 
                      : 0.0;
                  
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryExpensesPage(
                            category: categoryList[index].key,
                            expenseList: selectedExpenses,
                          ),
                        ),
                      );
                    },
                    leading: Icon(CategoryUtils.getIconForCategory(
                        categoryList[index].key)),
                    title: Text(categoryList[index].key.displayName),
                    subtitle: Text("${percentage.toStringAsFixed(2)}%"),
                    trailing: Text(
                      "₹${categoryList[index].value}",
                      style: const TextStyle(fontSize: 15),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}