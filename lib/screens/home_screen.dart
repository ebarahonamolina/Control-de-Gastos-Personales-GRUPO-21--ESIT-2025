import 'package:flutter/material.dart';
import '../widgets/edit_transaction.dart';
import '../widgets/transaction_list.dart';
import '../widgets/new_transaction.dart';
import '../data/local_storage.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Transaction> _transactions = []; // Lista local de gastos
  final _localStorage = LocalStorage(); // Instancia para persistencia local

  @override
  void initState() {
    super.initState();
    _loadTransactions(); // Carga los gastos al iniciar la app
  }

  //Carga los gastos almacenados y actualiza el estado
  Future<void> _loadTransactions() async {
    final loadedTransactions = await _localStorage.getTransactions();
    setState(() {
      _transactions.addAll(loadedTransactions);
    });
  }

  // Agrega un nuevo gasto a la lista y la guarda localmente
  void _addNewTransaction(
    String title,
    double amount,
    DateTime chosenDate,
    String category,
  ) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: chosenDate,
      category: category,
    );
    setState(() {
      _transactions.add(newTx);
    });
    _saveTransactions(); // Guarda la lista actualizada
  }

  // Muestra un diálogo de confirmación y elimina un gasto
  void _deleteTransaction(String id) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Estás seguro?'),
        content: Text('¿Deseas eliminar este gasto?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          TextButton(
            child: Text('Sí'),
            onPressed: () {
              setState(() {
                _transactions.removeWhere((tx) => tx.id == id);
              });
              _saveTransactions();
              Navigator.of(ctx).pop(true);
            },
          ),
        ],
      ),
    );
  }

  // Muestra el formulario para agregar un nuevo gasto
  void startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: NewTransaction(_addNewTransaction),
        );
      },
    );
  }

  // Ingresa a la pantalla de edición con el gasto actual
  void _editTransaction(Transaction existingTransaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTransaction(
          transaction: existingTransaction,
          onTransactionUpdated: _updateTransaction,
        ),
      ),
    );
  }

  // Actualiza un gasto existente
  void _updateTransaction(Transaction updatedTransaction) {
    final index = _transactions.indexWhere(
      (tx) => tx.id == updatedTransaction.id,
    );
    if (index != -1) {
      setState(() {
        _transactions.replaceRange(index, index + 1, [updatedTransaction]);
      });
      _saveTransactions(); // Guarda los cambios
    }
    Navigator.pop(context); // Cierra la pantalla de edición
  }

  // Guarda la lista de gastos en almacenamiento local
  Future<void> _saveTransactions() async {
    await _localStorage.saveTransactions(_transactions);
  }

  // Calcula el total de gastos
  double get _totalExpenses {
    return _transactions.fold(0.0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de Gastos'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Gastos Totales: ${NumberFormat.currency(locale: 'en_US', symbol: '\$').format(_totalExpenses)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TransactionList(
              //Lista de gastos
              _transactions,
              _deleteTransaction,
              _editTransaction,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //Boton para agregar gastos
        child: Icon(Icons.add),
        onPressed: () => startAddNewTransaction(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
