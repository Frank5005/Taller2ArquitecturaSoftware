// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      //date: date.toIso8601String(),
      category: _categoryStringToEnumMap[json['category']]!,
    );

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'amount': instance.amount,
      'date': instance.date.toIso8601String(),
      'category': _$CategoryEnumMap[instance.category]!,
    };

const _$CategoryEnumMap = {
  Category.food: 'food',
  Category.travel: 'travel',
  Category.leisure: 'leisure',
  Category.work: 'work',
};

const _categoryStringToEnumMap = {
  'food': Category.food,
  'travel': Category.travel,
  'leisure': Category.leisure,
  'work': Category.work,
};
