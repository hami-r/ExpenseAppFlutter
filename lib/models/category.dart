enum ExpenseCategory {
  food,
  shopping,
  bills,
  eatingOut,
  casualSpent,
  others,
  circle
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.shopping:
        return 'Shopping';
      case ExpenseCategory.bills:
        return 'Bills';
      case ExpenseCategory.eatingOut:
        return 'Eating Out';
      case ExpenseCategory.casualSpent:
        return 'Casual Spent';
      case ExpenseCategory.others:
        return 'Others';
      case ExpenseCategory.circle:
        return "Circle";
      default:
        return "Default";
    }
  }
}


