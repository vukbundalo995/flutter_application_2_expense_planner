import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransaction;

  const NewTransaction({required this.addTransaction, super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

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
    );
    // Closing the modal bottom sheet (top most screen)
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
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
            TextButton(
              onPressed: submitData,
              child: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
