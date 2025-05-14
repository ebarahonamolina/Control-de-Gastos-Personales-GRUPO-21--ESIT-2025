import 'package:flutter/material.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

// Widget que muestra una lista de transacciones
class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx; // Funcion para eliminar un gasto
  final Function editTx; // Funcion para editar un gasto

  // Constructor
  const TransactionList(this.transactions, this.deleteTx, this.editTx,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.hourglass_empty,
                    size: 80,
                    color: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Text(
                    '¡No hay transacciones aún!',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              // Si hay transacciones, crea una lista desplazable
              itemCount: transactions.length,
              itemBuilder: (ctx, index) {
                final tx = transactions[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                            NumberFormat.currency(locale: 'en_US', symbol: '\$')
                                .format(tx.amount),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      tx.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      '${tx.category} - ${DateFormat('dd/MM/yyyy ').format(tx.date)}',
                    ),
                    trailing: Row(
                      // Botones para editar y eliminar
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.blue,
                          onPressed: () => editTx(tx),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).colorScheme.error,
                          onPressed: () => deleteTx(tx.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
