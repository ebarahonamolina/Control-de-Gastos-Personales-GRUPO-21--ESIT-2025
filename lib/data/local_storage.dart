// Se importa el paquete shared_preferences para trabajar con almacenamiento local.
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/transaction.dart';

// Se define una clase llamada LocalStorage para manejar las operaciones de almacenamiento local.
class LocalStorage {
  static const _transactionsKey = 'transactions';
  // Se define un método asíncrono para guardar una lista de objetos Transaction.
  Future<void> saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final transactionList =
        transactions.map((t) => jsonEncode(t.toMap())).toList();
    await prefs.setStringList(_transactionsKey, transactionList);
  }

  // Se define un método asíncrono para obtener la lista de objetos Transaction almacenados.
  Future<List<Transaction>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactionListString = prefs.getStringList(_transactionsKey) ?? [];
    return transactionListString
        .map((jsonString) => Transaction.fromMap(jsonDecode(jsonString)))
        .toList();
  }
}
