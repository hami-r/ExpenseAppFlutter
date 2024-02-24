import 'package:expense_app/pages/monthly_page.dart';
import 'package:expense_app/pages/summary_page.dart';
import 'package:expense_app/providers/expense_provider.dart';
import 'package:expense_app/widgets/add_expense_dialog.dart';
import 'package:expense_app/widgets/amout_card.dart';
import 'package:expense_app/widgets/expense_list.dart';
import 'package:expense_app/widgets/week_expense_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  double todayTotal = 0;
  double weekTotal = 0;
  double monthTotal = 0;

  int selectedcardIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<ExpenseProvider>(context, listen: false).loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    todayTotal = expenseProvider.calculateExpenseOfToday();
    weekTotal = expenseProvider.calculateExpenseOfThisWeek();
    monthTotal = expenseProvider.calculateExpenseOfThisMonth();
    final today = DateTime.now();
    String formatDateTime = DateFormat('EEEE, d MMMM yyyy').format(today);
    return Scaffold(
      body: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatDateTime,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400
                ),),
                Row(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MonthlyPage())),
                        icon: const Icon(Icons.date_range_rounded)),
                    IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SummaryPage())),
                        icon: const Icon(Icons.pie_chart)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
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
              AmountCard(title: "Month",totalAmount: monthTotal),
            ],
          ),
          Container(
            height: 5,
            color: Colors.grey[350],
          ),
          ExpenseList(expenses: expenseProvider.expensesCurrentWeek)
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey.shade600,
          onPressed: () => AddExpenseDialog.show(context),
          child: const Icon(Icons.add, color: Colors.white,)),
    );
  }
}
