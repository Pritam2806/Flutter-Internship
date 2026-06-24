import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/expense.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();          // Creates Single instance
  static Database? _database;

  factory DatabaseHelper() {                               // For establishing single connection to DB, not many
    return _instance;
  }

  DatabaseHelper._internal();

  /// Get the database instance
  Future<Database> get database async {                    // Used whenever database access is needed.
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();       // Getting the app directory
    final path = join(documentsDirectory.path, 'expense_tracker.db');          // Create another path for DB.

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Create the expenses table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  /// Add a new expense
  Future<int> addExpense(Expense expense) async {
    final db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  /// Get all expenses
  Future<List<Expense>> getExpenses() async {
    final db = await database;
    final maps = await db.query('expenses', orderBy: 'date ASC');
    return List.generate(
      maps.length,
      (i) => Expense.fromMap(maps[i]),                     // fromMap function creates "Expense" from the "Map".
    );
  }

  /// Get expenses for a specific date
  Future<List<Expense>> getExpensesByDate(DateTime date) async {
    final db = await database;
    final dateStr = date.toIso8601String().split('T')[0];                   // normal date -> 2026-06-24T00:00:00.000
    final maps = await db.query(
      'expenses',
      where: 'DATE(date) = ?',
      whereArgs: [dateStr],
      orderBy: 'date ASC',
    );
    return List.generate(
      maps.length,
      (i) => Expense.fromMap(maps[i]),                     // fromMap function creates "Expense" from the "Map".
    );
  }

  /// Get expenses for a specific month
  Future<List<Expense>> getExpensesByMonth(int year, int month) async {
    final db = await database;
    final startDate = DateTime(year, month, 1).toIso8601String();
    final endDate = DateTime(year, month + 1, 1).toIso8601String();

    final maps = await db.query(
      'expenses',
      where: 'date >= ? AND date < ?',
      whereArgs: [startDate, endDate],
      orderBy: 'date ASC',
    );
    return List.generate(
      maps.length,
      (i) => Expense.fromMap(maps[i]),
    );
  }

  /// Delete an expense
  Future<int> deleteExpense(int id) async {
    final db = await database;
    return await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Update an expense
  Future<int> updateExpense(Expense expense) async {
    final db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  /// Get expenses for a specific year
  Future<List<Expense>> getExpensesByYear(int year) async {
    final db = await database;
    final startDate = DateTime(year, 1, 1).toIso8601String();
    final endDate = DateTime(year + 1, 1, 1).toIso8601String();

    final maps = await db.query(
      'expenses',
      where: 'date >= ? AND date < ?',
      whereArgs: [startDate, endDate],
      orderBy: 'date ASC',
    );
    return List.generate(
      maps.length,
      (i) => Expense.fromMap(maps[i]),
    );
  }
}
