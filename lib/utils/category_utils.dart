import 'package:expense_app/models/category.dart';
import 'package:flutter/material.dart';

class CategoryUtils {
  static final Map<ExpenseCategory, IconData> categoryIcons = {
    ExpenseCategory.food: Icons.fastfood,
    ExpenseCategory.shopping: Icons.shopping_cart,
    ExpenseCategory.bills: Icons.receipt,
    ExpenseCategory.eatingOut: Icons.restaurant,
    ExpenseCategory.casualSpent: Icons.attach_money,
    ExpenseCategory.fuel: Icons.local_gas_station,
    ExpenseCategory.others: Icons.category,
    ExpenseCategory.circle: Icons.circle,
  };

  static IconData getIconForCategory(ExpenseCategory category) {
    return categoryIcons[category] ?? Icons.circle;
  }
}