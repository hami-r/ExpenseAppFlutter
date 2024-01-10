import 'package:expense_app/data/expense_data.dart';
import 'package:flutter/foundation.dart';
import 'package:expense_app/models/expense.dart';

class ExpenseProvider extends ChangeNotifier {
  final List<Expense> _expenses = sampleExpenses;
  List<Expense> _expensesByDate = [];

  List<Expense> get expenses => _expenses;
  List<Expense> get expensesByDate => _expensesByDate;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  double calculateExpenseOfToday() {
    double expenseOfToday = _expenses
        .where((expense) => expense.isToday())
        .map((expense) => expense.amount ?? 0.0)
        .fold(0, (previous, current) => previous + current);
    return expenseOfToday;
  }

  double calculateExpenseOfThisWeek() {
    List<Expense> expensesForThisWeek = getExpensesForCurrentWeek();
    double expenseOfThisWeek = 0.0;

    for (var expense in expensesForThisWeek) {
      expenseOfThisWeek += expense.amount ?? 0.0;
    }
    return expenseOfThisWeek;
  }

  List<Expense> getExpensesForCurrentWeek() {
    DateTime now = DateTime.now();
    DateTime startOfWeek =
        now.subtract(Duration(days: now.weekday - DateTime.sunday + 7));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 8));
    print("$startOfWeek, $endOfWeek");
    return _expenses.where((expense) {
      DateTime expenseDate = expense.dateTime;
      return expenseDate.isAfter(startOfWeek) &&
          expenseDate.isBefore(endOfWeek);
    }).toList();
  }

  Map<String, double> getWeeklyExpenseMap() {
    final currentWeekExpenses = getExpensesForCurrentWeek();
    Map<String, double> weeklyExpenseMap = {
      'Sun': 0.0,
      'Mon': 0.0,
      'Tue': 0.0,
      'Wed': 0.0,
      'Thu': 0.0,
      'Fri': 0.0,
      'Sat': 0.0,
    };

    for (var expense in currentWeekExpenses) {
      String dayOfWeek = getDayOfWeek(expense.dateTime);
      weeklyExpenseMap[dayOfWeek] =
          (weeklyExpenseMap[dayOfWeek] ?? 0.0) + (expense.amount ?? 0.0);
    }
    return weeklyExpenseMap;
  }

  String getDayOfWeek(DateTime dateTime) {
    switch (dateTime.weekday) {
      case DateTime.sunday:
        return 'Sun';
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      default:
        return '';
    }
  }

  double calculateExpenseOfThisMonth() {
    DateTime currentDate = DateTime.now();
    DateTime startOfMonth = DateTime(currentDate.year, currentDate.month, 1);

    double expenseOfThisMonth = _expenses
        .where((expense) =>
            expense.dateTime.isAfter(startOfMonth) &&
            expense.dateTime.isBefore(currentDate))
        .map((expense) => expense.amount ?? 0.0)
        .fold(0, (previous, current) => previous + current);

    return expenseOfThisMonth;
  }

  void getExpenseByDate(DateTime? selectedDate) {
    selectedDate ??= DateTime.now();

    _expensesByDate = _expenses.where((expense) {
      return expense.dateTime.year == selectedDate!.year &&
          expense.dateTime.month == selectedDate.month &&
          expense.dateTime.day == selectedDate.day;
    }).toList();

    notifyListeners();
  }

  double calculateExpenseOfSelectedDate() {
    double totalExpense = _expensesByDate
        .map((expense) => expense.amount ?? 0.0)
        .fold(0, (previous, current) => previous + current);
    return totalExpense;
  }
}
