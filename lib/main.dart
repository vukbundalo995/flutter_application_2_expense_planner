import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.green,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        fontFamily: 'Quicksand',
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
// List of all transactions
  final List<Transaction> _userTransactions = [];

// Getting a list that contains only transactions from the last 7 days that we need to create a chart widget
  List<Transaction> get recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

// Adds a new transaction to the list and sets state (used in NewTransaction widget)
  void _addNewTransaction(String title, double amount) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: DateTime.now(),
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

// Opens a modal bottom sheet in order to add a new transaction
  startAddTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (bContext) {
          return NewTransaction(addTransaction: _addNewTransaction);
        });
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Expenses'),
        actions: [
          IconButton(
            onPressed: () => startAddTransaction(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Chart(
          recentTransactions: _userTransactions,
        ),
        TransactionList(
          transactions: recentTransactions,
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => startAddTransaction(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
