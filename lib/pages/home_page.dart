import 'package:expense_app/models/category.dart';
import 'package:expense_app/providers/expense_provider.dart';
import 'package:expense_app/widgets/add_expense_dialog.dart';
import 'package:expense_app/widgets/amout_card.dart';
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
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    todayTotal = expenseProvider.calculateExpenseOfToday();
    weekTotal = expenseProvider.calculateExpenseOfThisWeek();
    monthTotal = expenseProvider.calculateExpenseOfThisMonth();
    final expensesLength = expenseProvider.expenses.length;
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
                AmountCard(title: "This Month", totalAmount: monthTotal),
              ],
            ),
            Container(
              height: 5,
              color: Colors.grey[350],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: expensesLength,
                itemBuilder: (context,index){
                  var expense = expenseProvider.expenses[expensesLength-index-1];
                  return ListTile(
                    leading: Icon(getIconForCategory(expense.category)),
                    title: Text(expense.category.name),
                    subtitle: Text(expense.note.toString()),
                    trailing: Text("₹${expense.amount}",
                    style: const TextStyle(fontSize: 15),),
                  );
                }),
            )
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
