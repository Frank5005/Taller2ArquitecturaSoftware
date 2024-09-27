import 'package:flutter/material.dart';
//import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'expense.g.dart';

//part 'expense.g.dart';

final formatter = DateFormat.yMd();

enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.flight_takeoff,
  Category.leisure: Icons.movie,
  Category.work: Icons.work,
};

@JsonSerializable()
class Expense {
  Expense(
      {
      this.id,
      required this.title,
      required this.amount,
      required this.date,
      required this.category});

  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }

  // Método de fábrica para crear un Expense a partir de JSON
  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

  // Método para convertir un Expense a JSON
  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
            .where((expense) => expense.category == category)
            .toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for (var exp in expenses) {
      sum += exp.amount;
    }

    return sum;
  }
}
