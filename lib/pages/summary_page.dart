import 'package:expense_app/models/category.dart';
import 'package:expense_app/pages/category_expense_page.dart';
import 'package:expense_app/providers/expense_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_app/charts/piechart/expense_piechart.dart';
import 'package:provider/provider.dart';
import 'package:expense_app/utils/category_utils.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  late DateTime selectedDate;
  late DateTime startDate;
  late DateTime endDate;
  ExpenseCategory? selectedCategory;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day);
    startDate = selectedDate;
    endDate = selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final selectedExpenses = expenseProvider.getExpensesByDateRange(startDate, endDate);
    List<MapEntry<ExpenseCategory, double>> categoryList = expenseProvider
        .mapExpensesToCategories(selectedExpenses)
        .entries
        .toList();
    double totalAmount =
        categoryList.map((entry) => entry.value).fold(0, (a, b) => a + b);

    // Sorting the category list based on percentage
    categoryList.sort((a, b) {
      double percentageA = (a.value / totalAmount) * 100;
      double percentageB = (b.value / totalAmount) * 100;
      return percentageB.compareTo(percentageA);
    });

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
                      setState(() {
                        startDate = selectedDates.start;
                        endDate = selectedDates.end;
                      });
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
            const SizedBox(
              height: 55,
            ),
            SizedBox(
              height: 200,
              width: 200,
              child: ExpensePieChart(
                expenseProvider.getExpenseByDateRange(
                    startDate, endDate),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  double percentage =
                      (categoryList[index].value / totalAmount) * 100;
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
