import 'package:expense_app/models/category.dart';
import 'package:expense_app/pages/monthly_page.dart';
import 'package:expense_app/providers/expense_provider.dart';
import 'package:expense_app/widgets/add_expense_dialog.dart';
import 'package:expense_app/widgets/amout_card.dart';
import 'package:expense_app/widgets/expense_list.dart';
import 'package:expense_app/widgets/week_expense_chart.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MonthlyPage()));
                  },
                  child: AmountCard(title: "This Month", totalAmount: monthTotal,
                )),
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
          child: const Icon(Icons.add),
          onPressed: () => AddExpenseDialog.show(context)),
    );
  }

IconData getIconForCategory(Category category) {
  switch (category) {
    case Category.food:
      return Icons.fastfood;
    case Category.shopping:
      return Icons.shopping_cart;
    case Category.bills:
      return Icons.receipt;
    case Category.eatingOut:
      return Icons.restaurant;
    case Category.casualSpent:
      return Icons.attach_money;
    case Category.others:
      return Icons.category;
  }
}
  
}
