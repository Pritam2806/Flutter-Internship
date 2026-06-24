import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;

  const ExpenseTile({super.key,required this.expense,required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return ListTile(                                       // Widget
      leading: Text(
        dateFormat.format(expense.date),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      title: Text(
        expense.title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        '₹${expense.amount.toStringAsFixed(2)}',
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.black),
        onPressed: onDelete,
      ),
    );
  }
}
