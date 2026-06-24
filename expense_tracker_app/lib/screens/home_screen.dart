import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_chart.dart';
import '../widgets/expense_tile.dart';
import '../widgets/add_expense_dialog.dart';
import '../models/expense.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {                                       // Runs first time when the app opens.
    super.initState();
    // Load expenses when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseProvider>().loadExpenses();      // context.read() call to load expenses for first time
    });
  }

  void _showAddExpenseDialog() {
    showDialog(
      context: context,
      builder: (context) => AddExpenseDialog(
        onSave: (expense) async {
          // ignore: use_build_context_synchronously
          await context.read<ExpenseProvider>().addExpense(expense); // context.read() call to add the expenses.
          if (mounted) {                                             // Checks whether the screen still exists.
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(              // Snackbar functionality
              const SnackBar(content: Text('Expense added successfully')),
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(Expense expense, ExpenseProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text('Delete Expense?', style: TextStyle(color: Colors.black)),
        content: const Text('This action cannot be undone.', style: TextStyle(color: Colors.black87)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),  // Move back to previous screen
            child: const Text('Cancel', style: TextStyle(color: Colors.black87)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () async {
              await provider.deleteExpense(expense.id!);   // Provider call to delete the expense
              if (mounted) {                               // Check whether screen still exists
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();               // Move back to previous screen
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Expense deleted')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Expense Tracker', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Expense List Section (50% of screen height)
            Expanded(
              flex: 1,                                       // Taking 50% of the space.
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Toggle Button
                    Consumer<ExpenseProvider>(               // Listens to provider changes
                      builder: (context, provider, _) {
                        return Row(
                          children: [
                            Expanded(
                              child: SegmentedButton<bool>(  // Segmented button
                                segments: const [
                                  ButtonSegment<bool>(
                                    value: true,
                                    label: Text('Current Month'),
                                  ),
                                  ButtonSegment<bool>(
                                    value: false,
                                    label: Text('Whole Year'),
                                  ),
                                ],
                                selected: {provider.isMonthlyView},    // Which view is there
                                onSelectionChanged: (newSelection) {
                                  provider.toggleView();               // Provider updates
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.resolveWith(
                                    (states) {
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return Colors.black;
                                      }
                                      return Colors.white;
                                    },
                                  ),
                                  foregroundColor: WidgetStateProperty.resolveWith(
                                    (states) {
                                      if (states
                                          .contains(WidgetState.selected)) {
                                        return Colors.white;
                                      }
                                      return Colors.black;
                                    },
                                  ),
                                  side: WidgetStateProperty.all(
                                    const BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Chart Functionality
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const ExpenseChart(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 1, color: Colors.black12),   // Divider
            Expanded(
              flex: 1,
              child: Consumer<ExpenseProvider>(              // Listens to provider changes
                builder: (context, provider, _) {
                  if (provider.filteredExpenses.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text('No expenses found', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                        ],
                      ),
                    );
                  }
        
                  return ListView.builder(                   // for making the UI from a list
                    itemCount: provider.filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = provider.filteredExpenses[index]; 
                      return ExpenseTile(
                        expense: expense,
                        onDelete: () =>
                            _showDeleteConfirmation(expense, provider),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(          // floating action button
        backgroundColor: Colors.black,
        onPressed: _showAddExpenseDialog,                  // Adding new expense
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
