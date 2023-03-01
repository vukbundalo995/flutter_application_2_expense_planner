import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'widgets/new_transaction.dart';
import './models/transaction.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
        floatingActionButtonTheme:
            FloatingActionButtonThemeData(backgroundColor: Colors.green[800]),
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

  bool _showChart = false;

// Getting a list that contains only transactions from the last 7 days that we need to create a chart widget
  List<Transaction> get recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

// Adds a new transaction to the list and sets state (used in NewTransaction widget)
  void _addNewTransaction(String title, double amount, DateTime pickedDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: pickedDate,
    );

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
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
    final device = MediaQuery.of(context);
    final isLanscape = device.orientation == Orientation.landscape;
    final appBar = AppBar(
      title: const Text('Personal Expenses'),
      actions: [
        IconButton(
          onPressed: () => startAddTransaction(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );

    final screenHeight = device.size.height -
        appBar.preferredSize.height -
        device.padding.top -
        device.padding.bottom;
    final transactionListWidget = SizedBox(
      height: screenHeight * 0.7,
      child: TransactionList(
        transactions: _userTransactions,
        deleteTransaction: _deleteTransaction,
      ),
    );

    final pageBody = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isLanscape)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Show Chart'),
              Switch.adaptive(
                onChanged: (val) {
                  setState(() {
                    _showChart = val;
                  });
                },
                value: _showChart,
              ),
            ],
          ),
        if (!isLanscape)
          SizedBox(
            height: screenHeight * 0.3,
            child: Chart(
              recentTransactions: recentTransactions,
            ),
          ),
        if (!isLanscape) transactionListWidget,
        if (isLanscape)
          _showChart
              ? SizedBox(
                  height: screenHeight * 0.9,
                  child: Chart(
                    recentTransactions: recentTransactions,
                  ),
                )
              : transactionListWidget,
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: pageBody,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () => startAddTransaction(context),
              child: const Icon(Icons.add),
            ),
    );
  }
}
