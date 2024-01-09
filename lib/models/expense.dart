import 'package:expense_app/models/category.dart';

class Expense {
  double? amount;
  Category category;
  String? note;
  DateTime dateTime;

  Expense({
    required this.amount,
    required this.category,
    this.note,
    required DateTime dateTime,
  }) : dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute);

  int getYear() {
    return dateTime.year;
  }

  int getMonth() {
    return dateTime.month;
  }

  int getDay() {
    return dateTime.day;
  }

  int getWeek() {
    return dateTime.difference(DateTime(dateTime.year, 1, 1)).inDays ~/ 7 + 1;
  }

  bool isToday() {
    DateTime now = DateTime.now();
    return getYear() == now.year && getMonth() == now.month && getDay() == now.day;
  }

  String getTimeString() {
    // Format time as HH:mm
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
