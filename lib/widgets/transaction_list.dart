import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  const TransactionList(
      {required this.transactions, required this.deleteTransaction, super.key});

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No transactions added yet!'),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 107,
                      child: Text(
                        '\$${transactions[index].amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                title: Text(
                  transactions[index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  DateFormat('dd-MM-yy').format(transactions[index].date),
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: MediaQuery.of(context).size.width > 500
                    ? TextButton.icon(
                        onPressed: () =>
                            deleteTransaction(transactions[index].id),
                        icon: Icon(Icons.delete,
                            color: Theme.of(context).colorScheme.error),
                        label: Text('Delete',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error)),
                      )
                    : IconButton(
                        icon: const Icon(CupertinoIcons.delete),
                        onPressed: () =>
                            deleteTransaction(transactions[index].id),
                        color: Theme.of(context).colorScheme.error,
                      ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
