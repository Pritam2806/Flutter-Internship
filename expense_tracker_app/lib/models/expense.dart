class Expense {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;

  Expense({this.id, required this.title, required this.amount, required this.date});

  // Converting Expense to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  // Creating Expense from Map
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'] as int?,
      title: map['title'] as String,
      amount: map['amount'] as double,
      date: DateTime.parse(map['date'] as String),
    );
  }

  // Create a copy of Expense with modified fields
  Expense copyWith({int? id, String? title, double? amount, DateTime? date}) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  @override
  String toString() =>
      'Expense(id: $id, title: $title, amount: $amount, date: $date)';
}
