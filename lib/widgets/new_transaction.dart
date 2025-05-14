import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Widget con estado que permite al usuario ingresar un nuevo gasto
class NewTransaction extends StatefulWidget {
  final Function addTx;
  const NewTransaction(this.addTx, {super.key});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedCategory;

  final _categories = [
    // Lista de categorías disponibles
    'Comida',
    'Transporte',
    'Entretenimiento',
    'Salud',
    'Otros'
  ];

  void _presentDatePicker() {
    // Muestra un selector de fecha al usuario
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void _submitData() {
    // Valida y envía los datos del formulario
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      setState(() {}); // Para mostrar el error si la fecha no está seleccionada
      return;
    }

    widget.addTx(
      _titleController.text,
      double.parse(_amountController.text),
      _selectedDate!,
      _selectedCategory!,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextFormField(
                  // Campo de texto para la descripción
                  decoration: InputDecoration(labelText: 'Descripción'),
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Este campo es requerido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  // Campo de texto para el monto
                  decoration: InputDecoration(labelText: 'Monto'),
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    final amount = double.tryParse(value ?? '');
                    if (value == null || value.trim().isEmpty) {
                      return 'Este campo es requerido';
                    }
                    if (amount == null || amount <= 0) {
                      return 'Ingresa un monto válido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No se ha seleccionado ninguna fecha'
                            : 'Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                        style: TextStyle(
                          color: _selectedDate == null ? Colors.red : null,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: _presentDatePicker,
                      child: Text(
                        'Elegir fecha',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  // Dropdown para elegir categoría
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
                SizedBox(height: 20),
                ElevatedButton(
                  // Botón para enviar el formulario
                  onPressed: _submitData,
                  child: Text('Añadir Gasto'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
