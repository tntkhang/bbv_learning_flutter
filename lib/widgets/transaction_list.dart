import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TransactionList extends StatelessWidget {
  List<FlSpot> data;
  TransactionList({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: Card(
          elevation: 5,
          child: Center(
          ),
        )
    );
  }

}