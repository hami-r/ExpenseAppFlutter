class Expense {
  double amount;
  String category;
  String? description;
  String date;

  Expense({
    required this.amount,
    required this.category,
    this.description,
    required this.date,
  });

  DateTime getDateTime() {
    return DateTime.parse(date);
  }

  int getYear() {
    return getDateTime().year;
  }

  int getMonth() {
    return getDateTime().month;
  }

  int getDay() {
    return getDateTime().day;
  }

  int getWeek() {
    // Calculate the week number based on ISO 8601 standard
    return getDateTime().difference(DateTime(getYear(), 1, 1)).inDays ~/ 7 + 1;
  }
}
