import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  List<Map<String, Object>> get groupedTransactionValues {
    // Getting a list of 7 maps that each contains a day of the week and total amount for that day
    return List.generate(7, (index) {
      // creating a day of the week using the index
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      var totalSum = 0.0;
      // Looking for all transactions that happened on the same day that we created earlier in this iteration (weekDay) and adding their amounts to the total sum of that specific day
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      // returning a map that contains a day and his total amount sum
      return {'day': DateFormat('E').format(weekDay), 'amount': totalSum};
    });
  }

  Chart({required this.recentTransactions, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Row(
        children: groupedTransactionValues.map((data) {
          return Text('${data['day']}: ${data['amount']}');
        }).toList(),
      ),
    );
  }
}
