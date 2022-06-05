import 'package:bbv_learning_flutter/models/transaction_item.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:bbv_learning_flutter/extensions/date_extension.dart';

class Chart extends StatelessWidget {
  Map<DateTime, List<TransactionItem>> groupByDate;
  List<FlSpot> data;
  var maxAmount;
  Chart({Key? key, required this.groupByDate, required this.data, required this.maxAmount}) : super(key: key);

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.transparent,
      tooltipPadding: const EdgeInsets.all(0),
      tooltipMargin: 8,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    var date = groupByDate.keys.firstWhereIndexedOrNull((index, element) => index == value) ?? DateTime.now();
    return Center(child: Text(date.formatDate(), style: style));
  }

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false,),
    ),
    rightTitles: AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  FlBorderData get borderData => FlBorderData(
    show: false,
  );

  List<BarChartGroupData> _buildChartData() {
    List<BarChartGroupData> result = [];
    for (var value in data) {
      result.add( BarChartGroupData(
        x: value.x.toInt(),
        barRods: [
          BarChartRodData(
            toY: value.y,
            color: Colors.lightBlueAccent,
          )
        ],
        showingTooltipIndicators: [0],
      ));
    }
    return result.length - 7 > 0 ? result.sublist(result.length - 7) : result;
  }

  List<BarChartGroupData> get barGroups => _buildChartData();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: const Color(0xff2c4260),
      child: data.isNotEmpty ? BarChart(
        BarChartData(
          barTouchData: barTouchData,
          titlesData: titlesData,
          borderData: borderData,
          barGroups: barGroups,
          gridData: FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: maxAmount + (maxAmount/6),
        ),
      ) : const Center(
        child: Text("Chart is empty", style: TextStyle(color: Colors.white),),
      )
    );
  }

}