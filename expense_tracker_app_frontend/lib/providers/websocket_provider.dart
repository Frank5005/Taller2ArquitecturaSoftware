import 'package:flutter/material.dart';
import '../services/websocket_service.dart';
//import 'dart:convert';

class WebSocketProvider with ChangeNotifier {

  late WebSocketService _webSocketService;

  void connect(String url) {
    _webSocketService = WebSocketService(url);
  }

  void sendMessage(Map<String, dynamic> message) {
    _webSocketService.sendMessage(message);
  }

  Stream<Map<String, dynamic>> get messages => _webSocketService.messages;

  void close() {
    _webSocketService.close();
  }
}
