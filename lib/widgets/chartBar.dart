import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPercentageOfTotal;

  const ChartBar(
      {required this.label,
      required this.spendingAmount,
      required this.spendingPercentageOfTotal,
      super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constrainsts) {
      return Column(
        children: [
          SizedBox(height: constrainsts.maxHeight * 0.15, child: Text(label)),
          SizedBox(
            height: constrainsts.maxHeight * 0.05,
          ),
          SizedBox(
            height: constrainsts.maxHeight * 0.60,
            width: 10,
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(220, 220, 220, 1),
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPercentageOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(width: 1),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constrainsts.maxHeight * 0.05,
          ),
          SizedBox(
              height: constrainsts.maxHeight * 0.15,
              child: Text('\$${spendingAmount.toStringAsFixed(0)}')),
        ],
      );
    });
  }
}
