import 'dart:convert';
//import 'package:web_socket_channel/io.dart'; // Para la conexión WebSocket.
import 'package:web_socket_channel/web_socket_channel.dart'; // Para WebSocketChannel.
//import 'package:web_socket_channel/status.dart' as status;

class WebSocketService {
  final WebSocketChannel _channel;

  WebSocketService(String url) : _channel = WebSocketChannel.connect(Uri.parse(url));

  // Envía un mensaje al WebSocket
  void sendMessage(Map<String, dynamic> message) {
    _channel.sink.add(jsonEncode(message));
  }

  // Escucha mensajes del WebSocket
  Stream<Map<String, dynamic>> get messages => _channel.stream.map((event) => jsonDecode(event));

  // Cierra la conexión del WebSocket
  void close() {
    _channel.sink.close();
  }
}
