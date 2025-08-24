import 'package:flutter/material.dart';
import 'package:expense_app/models/category.dart';

class CategoryUtils {
  static final Map<ExpenseCategory, IconData> categoryIcons = {
    ExpenseCategory.food: Icons.fastfood,
    ExpenseCategory.shopping: Icons.shopping_cart,
    ExpenseCategory.bills: Icons.receipt,
    ExpenseCategory.eatingOut: Icons.restaurant,
    ExpenseCategory.casualSpent: Icons.wallet,
    ExpenseCategory.fuel: Icons.local_gas_station,
    ExpenseCategory.investment: Icons.money,
    ExpenseCategory.charity: Icons.clean_hands,
    ExpenseCategory.health: Icons.healing,
    ExpenseCategory.travel: Icons.flight,
    ExpenseCategory.others: Icons.category,
    ExpenseCategory.circle: Icons.circle,
  };

  static final Map<ExpenseCategory, Color> categoryColors = {
    ExpenseCategory.food: Colors.redAccent,
    ExpenseCategory.shopping: Colors.blueAccent,
    ExpenseCategory.bills: Colors.greenAccent,
    ExpenseCategory.eatingOut: Colors.orangeAccent,
    ExpenseCategory.casualSpent: Colors.purpleAccent,
    ExpenseCategory.fuel: Colors.limeAccent,
    ExpenseCategory.investment: Colors.lightGreenAccent,
    ExpenseCategory.charity: Colors.lightBlueAccent,
    ExpenseCategory.health: Colors.deepOrangeAccent,
    ExpenseCategory.travel: Colors.deepPurpleAccent,
    ExpenseCategory.others: Colors.tealAccent,
    ExpenseCategory.circle: Colors.white,
  };

  static IconData getIconForCategory(ExpenseCategory category) {
    return categoryIcons[category] ?? Icons.circle;
  }

  static Color getCategoryColor(ExpenseCategory category) {
    return categoryColors[category] ?? Colors.pinkAccent;
  }

  static ExpenseCategory parseCategory(String categoryString) {
    switch (categoryString) {
      case 'food':
        return ExpenseCategory.food;
      case 'shopping':
        return ExpenseCategory.shopping;
      case 'bills':
        return ExpenseCategory.bills;
      case 'eatingOut':
        return ExpenseCategory.eatingOut;
      case 'casualSpent':
        return ExpenseCategory.casualSpent;
      case 'fuel':
        return ExpenseCategory.fuel;
      case 'investment':
        return ExpenseCategory.investment;
      case 'charity':
        return ExpenseCategory.charity;
      case 'health':
        return ExpenseCategory.health;
      case 'travel':
        return ExpenseCategory.travel;
      case 'others':
        return ExpenseCategory.others;
      default:
        throw ArgumentError('Invalid category: $categoryString');
    }
  }
}
