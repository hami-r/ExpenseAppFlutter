import 'package:expense_app/data/expense_data.dart';
import 'package:expense_app/services/firestore_service.dart';
import 'package:flutter/foundation.dart';
import 'package:expense_app/models/expense.dart';
import 'package:expense_app/models/category.dart';
import 'package:intl/intl.dart';

class ExpenseProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Expense> _expenses = sampleExpenses;
  List<Expense> _expensesByDate = [];
  List<Expense> _expensesCurrentWeek = [];
  List<Expense> _expensesByMonth = [];

  List<Expense> get expenses => _expenses;
  List<Expense> get expensesByDate => _expensesByDate;
  List<Expense> get expensesCurrentWeek => _expensesCurrentWeek;
  List<Expense> get expensesByMonth => _expensesByMonth;

  Future<void> loadExpenses() async {
    try {
      List<Map<String, dynamic>> expensesData =
          await _firestoreService.getExpenses();
      _expenses = expensesData.map((data) => Expense.fromMap(data)).toList();
      _expenses.sort((a, b) => a.dateTime.compareTo(b.dateTime));
      _expensesCurrentWeek = getExpensesForCurrentWeek();
      getExpensesOfMonth(null);
      getExpenseByDate(null);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void addExpense(Expense expense) {
    _expenses.add(expense);
    _firestoreService.addExpense(expense.toMap());
    _expensesCurrentWeek = getExpensesForCurrentWeek();
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
    DateTime startOfWeek = now.subtract(Duration(
        days: now.weekday == 7 ? now.weekday - DateTime.sunday : now.weekday));
    DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));
    return _expenses.where((expense) {
      DateTime expenseDate = expense.dateTime;
      return expenseDate.year == startOfWeek.year &&
              expenseDate.month == startOfWeek.month &&
              expenseDate.day == startOfWeek.day ||
          (expenseDate.isAfter(startOfWeek) && expenseDate.isBefore(endOfWeek));
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
      String dayOfWeek = DateFormat('E').format(expense.dateTime);
      weeklyExpenseMap[dayOfWeek] =
          (weeklyExpenseMap[dayOfWeek] ?? 0.0) + (expense.amount ?? 0.0);
    }
    return weeklyExpenseMap;
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

  Map<DateTime, int> expenseMonthHeatmap(DateTime date) {
    Map<DateTime, int> heatMapDataset = {};
    for (var expense in _expenses) {
      DateTime expenseDate =
          DateTime(expense.getYear(), expense.getMonth(), expense.getDay());
      if (expenseDate.year == date.year && expenseDate.month == date.month) {
        heatMapDataset[expenseDate] = (heatMapDataset[expenseDate] ?? 0) + 1;
      }
    }
    return heatMapDataset;
  }

  void removeExpense(Expense expense) {
    _expenses.remove(expense);
    _firestoreService.removeExpense(expense.id);
    _expensesCurrentWeek = getExpensesForCurrentWeek();
    getExpenseByDate(expense.dateTime);
    getExpensesOfMonth(expense.dateTime);
    notifyListeners();
  }

  void getExpensesOfMonth(DateTime? date) {
    date ??= DateTime.now();
    DateTime startOfMonth = DateTime(date.year, date.month, 1);
    DateTime endOfMonth = DateTime(date.year, date.month + 1, 1)
        .subtract(const Duration(days: 1));
    _expensesByMonth = _expenses
        .where((expense) =>
            expense.dateTime.isAfter(startOfMonth) &&
            expense.dateTime.isBefore(endOfMonth))
        .toList();
    notifyListeners();
  }

  double calculateExpenseOfSelectedMonth() {
    double totalMonthlyExpense = _expensesByMonth
        .map((expense) => expense.amount ?? 0.0)
        .fold(0, (previous, current) => previous + current);
    return totalMonthlyExpense;
  }

  Map<ExpenseCategory, double> getExpenseByDateRange(
      DateTime startDate, DateTime endDate) {
    Map<ExpenseCategory, double> categoryMap = {};
    if (startDate.isAtSameMomentAs(endDate)) {
      endDate = endDate.add(const Duration(days: 1));
    }
    for (var expense in _expenses) {
      if (expense.dateTime.isAfter(startDate) &&
          expense.dateTime.isBefore(endDate)) {
        categoryMap[expense.category] =
            (categoryMap[expense.category] ?? 0.0) + (expense.amount ?? 0.0);
      }
    }
    return categoryMap;
  }
}
