import 'package:expense_tracker_app/widgets/chart/chart.dart';
import 'package:expense_tracker_app/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../providers/websocket_provider.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  @override
  void initState() {
    super.initState();
    // Carga los datos iniciales desde el backend cuando se inicializa el widget
    //Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ExpenseProvider>(context, listen: false).fetchExpenses();
    });
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) =>
          const NewExpense(), // No es necesario pasar onAddExpense
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(
        context); // Obtén el estado del ExpenseProvider
    final websocketProvider = Provider.of<WebSocketProvider>(
        context); // Obtén el estado del WebSocketProvider
    final width = MediaQuery.of(context).size.width;

    // Si no hay gastos registrados, muestra un mensaje
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    // Si hay gastos registrados, muestra la lista de gastos
    if (expenseProvider.expenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: expenseProvider.expenses,
        onRemoveExpense: (expense) {
          if (expense.id != null) {
            expenseProvider.deleteExpense(expense.id!); // Elimina el expense
            websocketProvider.sendMessage({
              'action': 'delete',
              'expense_id': expense.id!, // Notifica al WebSocket
            });
          } else {
            // Manejo de errores si el id es nulo (en teoría no debería pasar)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error: No se puede eliminar un expense sin id.'),
              ),
            );
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Expense Tracker App',
        ),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(
                    expenses: expenseProvider
                        .expenses), // Muestra el gráfico con los datos del provider
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(children: [
              Expanded(
                child: Chart(
                    expenses: expenseProvider
                        .expenses), // Muestra el gráfico con los datos del provider
              ),
              Expanded(
                child: mainContent,
              ),
            ]),
    );
  }
}
