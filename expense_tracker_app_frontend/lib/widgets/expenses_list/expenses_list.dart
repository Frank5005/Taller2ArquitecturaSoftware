import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense; // Función para eliminar el gasto

  @override
  Widget build(BuildContext context) {
    //final expenseProvider = Provider.of<ExpenseProvider>(context); // Accede al ExpenseProvider
    //final websocketProvider = Provider.of<WebSocketProvider>(context); // Accede al WebSocketProvider

    return ListView.builder(
      itemCount: expenses.length, // Utiliza la lista de gastos del provider
      itemBuilder: (context, index) {
        final expense = expenses[index];

        return Dismissible(
          key: ValueKey(expense.id), // Asegúrate de que el `id` no sea nulo
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          ),
          onDismissed: (direction) {
            if (expense.id != null) {
              onRemoveExpense(expense); // Elimina el expense
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error: No se puede eliminar un expense sin id.'),
                ),
              );
            }
          },
          child: ExpenseItem(expense), // Muestra el item de gasto
        );
      },
    );
  }
}
