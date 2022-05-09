import 'dart:math';

import 'package:bbv_learning_flutter/extensions/date_extension.dart';
import 'package:bbv_learning_flutter/models/transaction_item.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import '../widgets/chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<TransactionItem> items = <TransactionItem>[];
final titleController = TextEditingController();
final amountController = TextEditingController();
final dateController = TextEditingController();

class _HomeScreenState extends State<HomeScreen> {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  var lastSelectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    String formattedDate = formatter.format(now);
    dateController.text = formattedDate;
  }

  MaterialColor _getRandomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height*0.25,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (value) {
              dateController.text = value.formatDate();
              lastSelectedDate = value;
            },
            maximumDate: DateTime.now(),
            initialDateTime: lastSelectedDate,
          ),
        );
      }
    );
  }

  addTransaction() {
      setState(() {
        var randomColor = _getRandomColor();
        var newItem = TransactionItem(titleController.text,
            double.parse(amountController.text.toString()),
            lastSelectedDate, randomColor);
        items.add(newItem);
        items.sort((from, to) => from.date.compareTo(to.date));
      });
      Navigator.pop(context);

      titleController.text = "";
      amountController.text = "";
  }

  deleteTransaction(TransactionItem itemIndex) {
    setState(() {
      items.remove(itemIndex);
    });
  }

  showBottomSheetAddTransaction() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(15.0)
            )
        ),
        builder: (context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              margin: const EdgeInsets.only(left: 40.0, top: 20.0, right: 40.0, bottom: 40.0),
              child: Wrap(
                children: [
                  const Align(
                      alignment: Alignment.center,
                      child: Text("Add Transaction", style: TextStyle(fontSize: 30))),
                  const SizedBox(height: 50,),
                  CupertinoTextField(
                    placeholder: "Name",
                    keyboardType: TextInputType.text,
                    controller: titleController,
                  ),
                  const SizedBox(height: 40,),
                  CupertinoTextField(
                    placeholder: "Amount",
                    keyboardType: TextInputType.number,
                    controller: amountController,
                  ),
                  const SizedBox(height: 40,),
                  CupertinoTextField(
                    suffix: IconButton(
                      onPressed: () {_showDatePicker();},
                      icon: const Icon(Icons.date_range),
                    ),
                    readOnly: true,
                    placeholder: "Date",
                    keyboardType: TextInputType.datetime,
                    controller: dateController,
                    onTap: () {_showDatePicker();},
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Align(
                        alignment: Alignment.center,
                        child: CupertinoButton(onPressed: addTransaction, child: const Text("Add"))),
                  )
                ],
              ),
            )
        )
    );
  }

  Widget _buildChart() {
    List<FlSpot> data = [];
    double index = 0;
    double maxAmount = 0.0;

    var groupByDate = items.groupListsBy((obj) => obj.date);

    debugPrint("groupByDate: " + groupByDate.toString());

    for (var value in groupByDate.keys) {
      var totalAmount = 0.0;
      groupByDate[value]?.forEach((element) {
         totalAmount+= element.amount;
      });
      if (totalAmount > maxAmount) {
        maxAmount = totalAmount;
      }
      data.add(FlSpot(index, totalAmount));
      index++;
    }
    return Chart(groupByDate: groupByDate, data: data, maxAmount: maxAmount);
  }

  Widget _buildTransactionList() {
    return items.isNotEmpty ? Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Align(
                alignment: Alignment.centerLeft,
                child: Text("Transaction list",
                    style: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold))),
            Expanded(
              child: GroupedListView<dynamic, String>(
                elements: items,
                groupBy: (element) => (element.date as DateTime).formatDate(),
                groupSeparatorBuilder: (String value) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                itemBuilder: (context, dynamic element) => Card(
                    elevation: 2,
                    child: ListTile(
                      leading: Container(
                        margin: const EdgeInsets.all(1.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: element.amountColor)
                        ),
                        child: Text("\$" +
                            element.amount.toString(),
                          style: TextStyle(
                              color: element.amountColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(element.title,
                          style: const TextStyle(fontSize: 20)),
                      subtitle: Text((element.date as DateTime).formatDate(),
                        style: const TextStyle(fontSize: 14),),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          deleteTransaction(element);
                        },),
                    )
                ),
                order: GroupedListOrder.ASC,
              )
            )
          ],
        )
    ) : const Center(child: Text("No transaction added yet"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          CupertinoButton(
            onPressed: () {showBottomSheetAddTransaction();},
            child: const Text('ADD', style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18),),
          ),
        ],
        title: const Text('My App'),
        centerTitle: false,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: _buildChart(),
            ),
            Expanded(
              flex: 8,
              child: _buildTransactionList(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheetAddTransaction();
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
