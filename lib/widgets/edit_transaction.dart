import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

// Widget con estado que permite editar un gasto existente
class EditTransaction extends StatefulWidget {
  final Transaction transaction; // Gasto que se va a editar
  final Function(Transaction) onTransactionUpdated;

  const EditTransaction(
      {super.key,
      required this.transaction,
      required this.onTransactionUpdated});
  @override
  _EditTransactionState createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  late TextEditingController _titleController;
  late TextEditingController _amountController;
  DateTime? _selectedDate;
  String? _selectedCategory;

  final _categories = [
    // Lista de categorias disponibles
    'Comida',
    'Transporte',
    'Entretenimiento',
    'Salud',
    'Otros'
  ];

  @override // Inicializa los valores con los datos del gasto original
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.transaction.title);
    _amountController =
        TextEditingController(text: widget.transaction.amount.toString());
    _selectedDate = widget.transaction.date;
    _selectedCategory = widget.transaction.category;
  }

  void _presentDatePicker() {
    // Muestra un selector de fecha y actualiza el estado si se selecciona una
    showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _updateTransaction() {
    // Valida los campos y actualiza la transacción
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text);
    // Validacion de campos
    if (enteredTitle.isEmpty ||
        enteredAmount == null ||
        enteredAmount <= 0 ||
        _selectedDate == null ||
        _selectedCategory == null) {
      // Mostrar mensaje de error o validación
      return;
    }

    // Se crea una nueva instancia de Transaction con los cambios aplicados
    final updatedTx = Transaction(
      id: widget.transaction.id,
      title: enteredTitle,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory!,
    );

    widget.onTransactionUpdated(updatedTx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Gasto'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Descripción'),
              controller: _titleController,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Monto'),
              controller: _amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No se ha seleccionado ninguna fecha'
                        : 'Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                  ),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: Text(
                    'Cambiar fecha',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Categoría'),
              value: _selectedCategory,
              items: _categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              validator: (value) =>
                  value == null ? 'Selecciona una categoría' : null,
            ),
            ElevatedButton(
              // Botón para guardar los cambios
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: _updateTransaction,
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
