import 'package:expense_app/pages/monthly_page.dart';
import 'package:expense_app/pages/summary_page.dart';
import 'package:expense_app/providers/expense_provider.dart';
import 'package:expense_app/widgets/add_expense_dialog.dart';
import 'package:expense_app/widgets/amout_card.dart';
import 'package:expense_app/widgets/expense_list.dart';
import 'package:expense_app/widgets/week_expense_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomePage extends ConsumerWidget {  // Changed from StatefulWidget to ConsumerWidget
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {  // Added WidgetRef parameter
    // Watch the providers instead of using Provider.of
    final todayTotal = ref.watch(todayTotalProvider);
    final weekTotal = ref.watch(weekTotalProvider);
    final monthTotal = ref.watch(monthTotalProvider);
    final currentWeekExpenses = ref.watch(currentWeekExpensesProvider);
    
    final today = DateTime.now();
    String formatDateTime = DateFormat('EEEE, d MMMM yyyy').format(today);
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDateTime,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MonthlyPage(),
                          ),
                        ),
                        icon: const Icon(Icons.date_range_rounded),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SummaryPage(),
                          ),
                        ),
                        icon: const Icon(Icons.pie_chart),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            const WeekExpenseChart(),
            Container(
              height: 5,
              color: Colors.grey[350],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AmountCard(title: "Today", totalAmount: todayTotal),
                AmountCard(title: "Week", totalAmount: weekTotal),
                AmountCard(title: "Month", totalAmount: monthTotal),
              ],
            ),
            Container(
              height: 5,
              color: Colors.grey[350],
            ),
            ExpenseList(expenses: currentWeekExpenses),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade600,
        onPressed: () => AddExpenseDialog.show(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}