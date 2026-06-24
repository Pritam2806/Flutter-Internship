import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../database/database_helper.dart';

class ExpenseProvider extends ChangeNotifier {
  // Since above extends ChangeNotifier, widgets using Consumer<ExpenseProvider> automatically rebuild when data changes.
  final DatabaseHelper _databaseHelper = DatabaseHelper();           // Creates a database helper object for DB operations

  List<Expense> _allExpenses = [];
  List<Expense> _filteredExpenses = [];
  bool _isMonthlyView = true;
  final DateTime _selectedDate = DateTime.now();
  int _selectedDay = DateTime.now().day;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  // Getters
  List<Expense> get filteredExpenses => _filteredExpenses;
  bool get isMonthlyView => _isMonthlyView;
  DateTime get selectedDate => _selectedDate;
  int get selectedDay => _selectedDay;
  int get selectedMonth => _selectedMonth;
  int get selectedYear => _selectedYear;
  List<Expense> get allExpenses => _allExpenses;

  // Load all expenses from database
  Future<void> loadExpenses() async {
    _allExpenses = await _databaseHelper.getExpenses();    // Get the expenses
    _filterByCurrentSelection();                           // Ensures filtered list updates
    notifyListeners();                                     // Consumer widget rebuilds
  }

  // Add a new expense
  Future<void> addExpense(Expense expense) async {
    await _databaseHelper.addExpense(expense);
    await loadExpenses();                                  // Fetches fresh data, Updates filters, Refreshes UI
  }

  // Delete an expense
  Future<void> deleteExpense(int id) async {
    await _databaseHelper.deleteExpense(id);
    await loadExpenses();                                  // Fetches fresh data, Updates filters, Refreshes UI
  }

  // Toggle between monthly and yearly view
  void toggleView() {
    _isMonthlyView = !_isMonthlyView;
    if (_isMonthlyView) {
      _selectedDay = DateTime.now().day;                   // When returning to monthly view, current day becomes selected.
    }
    _filterByCurrentSelection();                           // Ensures filtered list updates
    notifyListeners();                                     // Consumer widget rebuilds
  }

  // Set the selected day (for monthly view)
  void setSelectedDay(int day) {                           // Used when user taps a "day" in chart.
    _selectedDay = day;
    _filterByDay();                                        // Filter the expenses
    notifyListeners();                                     // Consumer widget rebuilds
  }

  // Set the selected month (for yearly view)
  void setSelectedMonth(int month) {
    _selectedMonth = month;
    _filterByMonth();                                      // Filters expenses for one specific day.
    notifyListeners();                                     // Consumer widget rebuilds
  }

  // Set the selected year
  void setSelectedYear(int year) {
    _selectedYear = year;
    _filterByCurrentSelection();
    notifyListeners();                                     // Consumer widget rebuilds
  }

  // Filter expenses by the current selection
  void _filterByCurrentSelection() {
    if (_isMonthlyView) {
      _filterByDay();
    } else {
      _filterByMonth();
    }
  }

  // Filter expenses by day [Filters expenses for one specific day.]
  void _filterByDay() {
    final selectedDate = DateTime(_selectedYear, _selectedMonth, _selectedDay);
    _filteredExpenses = _allExpenses.where((expense) {               // "where" used for filtering
      return expense.date.year == selectedDate.year &&
          expense.date.month == selectedDate.month &&
          expense.date.day == selectedDate.day;
    }).toList();
  }

  // Filter expenses by month [Filters expenses for one specific month.]
  void _filterByMonth() {
    _filteredExpenses = _allExpenses.where((expense) {               // "where" used for filtering
      return expense.date.year == _selectedYear &&
          expense.date.month == _selectedMonth;
    }).toList();
  }

  // Get total expenses for a day
  double getTotalExpenseForDay(int day) {
    final date = DateTime(_selectedYear, _selectedMonth, day);
    return _allExpenses
        .where((expense) =>
            expense.date.year == date.year &&
            expense.date.month == date.month &&
            expense.date.day == date.day
        ).fold(0, (sum, expense) => sum + expense.amount);
  }

  // Get total expenses for a month
  double getTotalExpenseForMonth(int month) {
    return _allExpenses
        .where((expense) =>
            expense.date.year == _selectedYear && 
            expense.date.month == month
        ).fold(0, (sum, expense) => sum + expense.amount);
  }

  // Get max expense amount for the current view
  double getMaxExpenseAmount() {                           // For setting the heights of the bar. (Relative sizing)
    if (_filteredExpenses.isEmpty) return 0;
    return _allExpenses.fold(
        0, (max, expense) => expense.amount > max ? expense.amount : max);
  }

  // Get all months in selected year that have expenses
  List<int> getMonthsWithExpenses() {
    final months = <int>{};                                // Set DS used to remove duplicates
    for (final expense in _allExpenses) {
      if (expense.date.year == _selectedYear) {
        months.add(expense.date.month);
      }
    }
    return months.toList()..sort();                        // Converting map to list and then do sorting
  }

  // Get all days in selected month that have expenses
  List<int> getDaysWithExpenses() {
    final days = <int>{};                                  // Set DS used to remove duplicates
    for (final expense in _allExpenses) {
      if (expense.date.year == _selectedYear && expense.date.month == _selectedMonth) {
        days.add(expense.date.day);
      }
    }
    return days.toList()..sort();                          // Converting map to list and then do sorting
  }
}
