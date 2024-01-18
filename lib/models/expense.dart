import 'package:expense_app/models/category.dart';
import 'package:uuid/uuid.dart';

class Expense {
  String id;
  double? amount;
  Category category;
  String? note;
  DateTime dateTime;

  Expense({
    String? id,
    required this.amount,
    required this.category,
    this.note,
    required DateTime dateTime,
  }) : dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
            dateTime.hour, dateTime.minute), id = id ?? const Uuid().v6();

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

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'amount': amount,
      'category': category.toString().split('.').last,
      'note': note,
      'dateTime': dateTime.toUtc(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount'],
      category: _parseCategory(map['category']), 
      note: map['note'],
      dateTime: map['dateTime'].toDate(),
    );
  }

  static Category _parseCategory(String categoryString) {
    switch (categoryString) {
      case 'food':
        return Category.food;
      case 'shopping':
        return Category.shopping;
      case 'bills':
        return Category.bills;
      case 'eatingOut':
        return Category.eatingOut;
      case 'casualSpent':
        return Category.casualSpent;
      case 'others':
        return Category.others;
      default:
        throw ArgumentError('Invalid category: $categoryString');
    }
  }
  @override
  String toString() {
  return 'Expense(id: $id, amount: $amount, category: $category, note: $note, date: ${dateTime.toString().split(' ')[0]})\n';
  }
}
