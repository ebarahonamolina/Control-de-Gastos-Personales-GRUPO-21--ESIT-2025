class Transaction {
  String id;
  String title;
  double amount;
  DateTime date;
  String category;

  // Se define el constructor de la clase Transaction.
  // Utiliza parámetros con nombre y marcados como 'required', lo que significa que deben proporcionarse al crear una instancia de Transaction.
  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['category'],
    );
  }
}
