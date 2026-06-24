import 'package:flutter/material.dart';
import 'package:intl/intl.dart';                           // Used for formatting dates
import '../models/expense.dart';

class AddExpenseDialog extends StatefulWidget {
  final Function(Expense) onSave;                          

  const AddExpenseDialog({super.key, required this.onSave});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _titleController = TextEditingController();        // Controlling the user input.
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();                 // Current date of system

  @override
  void dispose() {                                         // Freeing up the memory
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(               // Making calender visible
      context: context,
      initialDate: _selectedDate,                          // Current date of the system in starting
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;                        // Setting up the date
      });
    }
  }

  bool _validateInput() {                                  // Ensures correct user input
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter expense title')),
      );
      return false;
    }

    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter amount')),
      );
      return false;
    }

    try {
      double.parse(_amountController.text);                // Checking for double value (Converting text to double)
    } 
    catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');          // Formates date as "28 Jun 2026"

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(                      // Prevents overflow when keyboard appears
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Expense', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Expense Title',
                  labelStyle: const TextStyle(color: Colors.black87),
                  hintText: 'e.g., Pizza, Fuel, Movie',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: const TextStyle(color: Colors.black87),
                  hintText: 'e.g., 250',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              InkWell(                                     // Makes the widget tappable (Calender icon)
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.black),
                      const SizedBox(width: 12),
                      Text(dateFormat.format(_selectedDate), style: const TextStyle(fontSize: 16, color: Colors.black)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel', style: TextStyle(color: Colors.black87))),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_validateInput()) {
                        final expense = Expense(
                          title: _titleController.text,
                          amount: double.parse(_amountController.text),
                          date: _selectedDate,
                        );
                        widget.onSave(expense);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
