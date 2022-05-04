import 'package:bbv_learning_flutter/models/transaction_item.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Chart extends StatelessWidget {
  List<TransactionItem> items;
  List<FlSpot> data;
  Chart({Key? key, required this.items, required this.data}) : super(key: key);

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
    return Center(child: Text(items[value.toInt()].date, style: style));
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

  final _barsGradient = const LinearGradient(
    colors: [
      Colors.lightBlueAccent,
      Colors.greenAccent,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> _buildChartData() {
    List<BarChartGroupData> result = [];
    for (var value in data) {
      result.add( BarChartGroupData(
        x: value.x.toInt(),
        barRods: [
          BarChartRodData(
            toY: value.y,
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      ));
    }
    return result.length - 7 > 0 ? result.sublist(result.length - 7) : result;
  }

  List<BarChartGroupData> get barGroups => _buildChartData();

  double _getMaxY() {
    var result = items[0].amount;
    for (var value in items) {
      if (value.amount > result) {
        result = value.amount;
      }
    }
    return result + 180;
  }

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
          maxY: _getMaxY(),
        ),
      ) : const Center(
        child: Text("Chart is empty", style: TextStyle(color: Colors.white),),
      )
    );
  }

}