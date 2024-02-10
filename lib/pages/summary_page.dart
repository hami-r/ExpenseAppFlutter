import 'package:expense_app/models/category.dart';
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
    List<MapEntry<ExpenseCategory, double>> categoryList = expenseProvider
        .getExpenseByDateRange(startDate, endDate)
        .entries
        .toList();
    double totalAmount =
        categoryList.map((entry) => entry.value).fold(0, (a, b) => a + b);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
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
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  double percentage =
                      (categoryList[index].value / totalAmount) * 100;
                  return ListTile(
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
