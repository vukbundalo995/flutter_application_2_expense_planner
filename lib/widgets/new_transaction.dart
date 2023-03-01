import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  const NewTransaction({required this.addTransaction, super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _pickedDate = DateTime.now();

// Validatig data that user submitted and adding a new transaction
  submitData() {
    var eneteredTitle = titleController.text;
    var enteredAmount = amountController.text;

    // checking if fields for title or amount are empty
    if (eneteredTitle.isEmpty || enteredAmount.isEmpty) {
      return;
      // checking if entered amount only contains numbers
    } else if (!RegExp(r'^\d+$').hasMatch(enteredAmount)) {
      return;
      // checking if amount is less or equal to zero
    } else if (double.parse(enteredAmount) <= 0) {
      return;
    }
    // adding a new transaction to the list
    widget.addTransaction(
      eneteredTitle,
      double.parse(enteredAmount),
      _pickedDate,
    );
    // Closing the modal bottom sheet (top most screen)
    Navigator.of(context).pop();
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((selectedDate) {
      if (selectedDate == null) {
        return;
      }
      setState(() {
        _pickedDate = selectedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            left: 10,
            right: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) => submitData(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat.yMd().format(_pickedDate)),
                  TextButton(
                    onPressed: _showDatePicker,
                    child: Text(
                      'Choose date',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                  )
                ],
              ),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.primary),
                onPressed: submitData,
                child: const Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
