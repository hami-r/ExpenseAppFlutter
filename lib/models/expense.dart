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
    return getYear() == now.year &&
        getMonth() == now.month &&
        getDay() == now.day;
  }

  String formatDateTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String day = twoDigits(dateTime.day);
    String month = twoDigits(dateTime.month);
    String year = twoDigits(dateTime.year % 100); // Using % 100 for a two-digit year
    String hour = twoDigits(dateTime.hour);
    String minute = twoDigits(dateTime.minute);

    return '$day/$month/$year $hour:$minute';
  }
}
