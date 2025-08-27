import 'package:expense_app/models/payment_type.dart';
import 'package:expense_app/services/firestore_service.dart';
import 'package:expense_app/models/expense.dart';
import 'package:expense_app/models/category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Service provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Stream provider for real-time expenses from Firebase
final expensesStreamProvider = StreamProvider<List<Expense>>((ref) {
  return FirebaseFirestore.instance
      .collection('expenses')
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => Expense.fromMap(doc.data()))
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  });
});

// Provider for current week expenses
final currentWeekExpensesProvider = Provider<List<Expense>>((ref) {
  final expensesAsync = ref.watch(expensesStreamProvider);
  return expensesAsync.when(
    data: (expenses) => _getExpensesForCurrentWeek(expenses),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Provider for today's total
final todayTotalProvider = Provider<double>((ref) {
  final expensesAsync = ref.watch(expensesStreamProvider);
  return expensesAsync.when(
    data: (expenses) => expenses
        .where((expense) => expense.isToday())
        .fold(0.0, (sum, expense) => sum + (expense.amount ?? 0.0)),
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

// Provider for this week's total
final weekTotalProvider = Provider<double>((ref) {
  final weekExpenses = ref.watch(currentWeekExpensesProvider);
  return weekExpenses.fold(0.0, (sum, expense) => sum + (expense.amount ?? 0.0));
});

// Provider for this month's total
final monthTotalProvider = Provider<double>((ref) {
  final expensesAsync = ref.watch(expensesStreamProvider);
  return expensesAsync.when(
    data: (expenses) => _calculateExpenseOfThisMonth(expenses),
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

// Provider for weekly expense map (for charts)
final weeklyExpenseMapProvider = Provider<Map<String, double>>((ref) {
  final weekExpenses = ref.watch(currentWeekExpensesProvider);
  return _getWeeklyExpenseMap(weekExpenses);
});

// State provider for selected date (for monthly view)
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// Provider for expenses by selected date
final expensesByDateProvider = Provider<List<Expense>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  final expensesAsync = ref.watch(expensesStreamProvider);
  
  return expensesAsync.when(
    data: (expenses) => expenses.where((expense) {
      return expense.dateTime.year == selectedDate.year &&
          expense.dateTime.month == selectedDate.month &&
          expense.dateTime.day == selectedDate.day;
    }).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Provider for selected date total
final selectedDateTotalProvider = Provider<double>((ref) {
  final expensesByDate = ref.watch(expensesByDateProvider);
  return expensesByDate.fold(0.0, (sum, expense) => sum + (expense.amount ?? 0.0));
});

// State provider for selected month
final selectedMonthProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

// Provider for expenses by selected month
final expensesByMonthProvider = Provider<List<Expense>>((ref) {
  final selectedMonth = ref.watch(selectedMonthProvider);
  final expensesAsync = ref.watch(expensesStreamProvider);
  
  return expensesAsync.when(
    data: (expenses) => _getExpensesOfMonth(expenses, selectedMonth),
    loading: () => [],
    error: (_, __) => [],
  );
});

// Provider for selected month total
final selectedMonthTotalProvider = Provider<double>((ref) {
  final expensesByMonth = ref.watch(expensesByMonthProvider);
  return expensesByMonth.fold(0.0, (sum, expense) => sum + (expense.amount ?? 0.0));
});

// Provider for expense heatmap
final expenseHeatmapProvider = Provider.family<Map<DateTime, int>, DateTime>((ref, date) {
  final expensesAsync = ref.watch(expensesStreamProvider);
  return expensesAsync.when(
    data: (expenses) => _expenseMonthHeatmap(expenses, date),
    loading: () => {},
    error: (_, __) => {},
  );
});

// Actions provider for CRUD operations
final expenseActionsProvider = Provider<ExpenseActions>((ref) {
  return ExpenseActions(ref);
});

class ExpenseActions {
  final Ref ref;
  ExpenseActions(this.ref);

  Future<void> addExpense(Expense expense) async {
    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.addExpense(expense.toMap());
  }

  Future<void> removeExpense(Expense expense) async {
    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.removeExpense(expense.id);
  }

  Future<void> editExpense(Expense oldExpense, Expense newExpense) async {
    final firestoreService = ref.read(firestoreServiceProvider);
    await firestoreService.updateExpense(oldExpense.id, newExpense.toMap());
  }

  void setSelectedDate(DateTime date) {
    ref.read(selectedDateProvider.notifier).state = date;
  }

  void setSelectedMonth(DateTime date) {
    ref.read(selectedMonthProvider.notifier).state = date;
  }

  // Utility methods for filtering
  List<Expense> getExpensesForCategory(ExpenseCategory category, List<Expense> expenseList) {
    return expenseList.where((expense) => expense.category == category).toList();
  }

  List<Expense> getExpensesByDateRange(List<Expense> expenses, DateTime startDate, DateTime endDate) {
    final adjustedEndDate = endDate.add(const Duration(days: 1));
    return expenses.where((expense) =>
        expense.dateTime.isAfter(startDate) &&
        expense.dateTime.isBefore(adjustedEndDate)).toList();
  }

  Map<ExpenseCategory, double> mapExpensesToCategories(List<Expense> expenses) {
    Map<ExpenseCategory, double> categoryMap = {};
    for (var expense in expenses) {
      categoryMap[expense.category] =
          (categoryMap[expense.category] ?? 0.0) + (expense.amount ?? 0.0);
    }
    return categoryMap;
  }

  Map<ExpenseCategory, double> getExpenseByDateRange(List<Expense> expenses, DateTime startDate, DateTime endDate) {
    final adjustedEndDate = endDate.add(const Duration(days: 1));
    Map<ExpenseCategory, double> categoryMap = {};
    
    for (var expense in expenses) {
      if (expense.dateTime.isAfter(startDate) &&
          expense.dateTime.isBefore(adjustedEndDate)) {
        categoryMap[expense.category] =
            (categoryMap[expense.category] ?? 0.0) + (expense.amount ?? 0.0);
      }
    }
    return categoryMap;
  }
}

// Helper functions (private)
List<Expense> _getExpensesForCurrentWeek(List<Expense> expenses) {
  DateTime now = DateTime.now();
  int daysFromMonday = now.weekday - 1;
  DateTime startOfWeek = DateTime(now.year, now.month, now.day)
      .subtract(Duration(days: daysFromMonday));
  DateTime endOfWeek = startOfWeek.add(const Duration(days: 7));
  
  return expenses.where((expense) {
    DateTime expenseDate = DateTime(
      expense.dateTime.year,
      expense.dateTime.month,
      expense.dateTime.day,
    );
    return expenseDate.isAtSameMomentAs(startOfWeek) ||
           (expenseDate.isAfter(startOfWeek) && expenseDate.isBefore(endOfWeek));
  }).toList();
}

double _calculateExpenseOfThisMonth(List<Expense> expenses) {
  DateTime currentDate = DateTime.now();
  DateTime startOfMonth = DateTime(currentDate.year, currentDate.month, 1);
  DateTime endOfMonth = DateTime(currentDate.year, currentDate.month + 1, 1);

  return expenses
      .where((expense) =>
          expense.dateTime.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
          expense.dateTime.isBefore(endOfMonth))
      .fold(0.0, (sum, expense) => sum + (expense.amount ?? 0.0));
}

Map<String, double> _getWeeklyExpenseMap(List<Expense> currentWeekExpenses) {
  final Map<String, double> weeklyExpenseMap = {
    'Sun': 0.0, 'Mon': 0.0, 'Tue': 0.0, 'Wed': 0.0,
    'Thu': 0.0, 'Fri': 0.0, 'Sat': 0.0,
  };

  for (var expense in currentWeekExpenses) {
    final dayOfWeek = DateFormat('E').format(expense.dateTime);
    weeklyExpenseMap[dayOfWeek] = weeklyExpenseMap[dayOfWeek]! + (expense.amount ?? 0.0);
  }
  return weeklyExpenseMap;
}

List<Expense> _getExpensesOfMonth(List<Expense> expenses, DateTime date) {
  DateTime startOfMonth = DateTime(date.year, date.month, 1);
  DateTime endOfMonth = DateTime(date.year, date.month + 1, 1);
  
  return expenses
      .where((expense) =>
          expense.dateTime.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
          expense.dateTime.isBefore(endOfMonth))
      .toList();
}

Map<DateTime, int> _expenseMonthHeatmap(List<Expense> expenses, DateTime date) {
  Map<DateTime, int> heatMapDataset = {};
  for (var expense in expenses) {
    DateTime expenseDate =
        DateTime(expense.getYear(), expense.getMonth(), expense.getDay());
    if (expenseDate.year == date.year && expenseDate.month == date.month) {
      heatMapDataset[expenseDate] = (heatMapDataset[expenseDate] ?? 0) + 1;
    }
  }
  return heatMapDataset;
}

Map<PaymentType, double> mapExpensesToPaymentTypes(List<Expense> expenses) {
  Map<PaymentType, double> paymentTypeMap = {};
  for (var expense in expenses) {
    paymentTypeMap[expense.paymentType] =
        (paymentTypeMap[expense.paymentType] ?? 0.0) + (expense.amount ?? 0.0);
  }
  return paymentTypeMap;
}

