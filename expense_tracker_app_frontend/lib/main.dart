import 'package:flutter/material.dart';
import 'package:expense_tracker_app/widgets/expenses.dart';
import 'package:provider/provider.dart';
import 'providers/expense_provider.dart';
import 'providers/websocket_provider.dart';
//import 'package:flutter/services.dart';

// Definición de los esquemas de colores personalizados
var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 14, 180, 221));

var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 5, 99, 125),
  brightness: Brightness.dark,
);

void main() {
  final websocketProvider = WebSocketProvider();
  websocketProvider.connect('ws://192.168.10.18:8094/ws/expenses/');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WebSocketProvider>(
            create: (_) => websocketProvider),
        ChangeNotifierProvider<ExpenseProvider>(
          create: (_) => ExpenseProvider(websocketProvider),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
            backgroundColor: kDarkColorScheme.primaryContainer,
          ),
        ),
      ),
      theme: ThemeData().copyWith(
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                color: kColorScheme.onSecondaryContainer,
                fontSize: 16,
              ),
            ),
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode
          .system, // Selección automática del modo de tema basado en la configuración del sistema
      home:
          const Expenses(), // Widget principal para mostrar la lista de gastos
    );
  }
}
