import 'package:flutter/material.dart';
import '../models/expense.dart';
//import '../services/api_service.dart';
//import 'package:expense_tracker_app/services/websocket_service.dart';
//import 'dart:convert';
import 'websocket_provider.dart';

class ExpenseProvider with ChangeNotifier {
  final WebSocketProvider _webSocketProvider;
  List<Expense> _expenses = [];

  ExpenseProvider(this._webSocketProvider) {
    _webSocketProvider.messages.listen(_handleWebSocketMessages);
    fetchExpenses();
  }

  List<Expense> get expenses => _expenses;

  void fetchExpenses() {
    _webSocketProvider.sendMessage({
      'action': 'read',
    });
  }

  void addExpense(Expense expense) {
    _webSocketProvider.sendMessage({
      'action': 'create',
      'expense': expense.toJson(),
    });
  }

  void updateExpense(Expense expense) {
    _webSocketProvider.sendMessage({
      'action': 'update',
      'expense': expense.toJson(),
    });
  }

  void deleteExpense(int id) {
    _webSocketProvider.sendMessage({
      'action': 'delete',
      'expense_id': id,
    });
  }

  void _handleWebSocketMessages(Map<String, dynamic> message) {
    if (message['action'] == 'update_list') {
      _expenses = (message['expenses'] as List)
          .map((e) => Expense.fromJson(e))
          .toList();
      notifyListeners();
    }
  }
}
