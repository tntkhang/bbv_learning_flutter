import 'dart:developer';
import 'dart:math';

import 'package:bbv_learning_flutter/components/chart.dart';
import 'package:bbv_learning_flutter/models/transaction_item.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  var lastSeletedDate;

  @override
  void initState() {
    super.initState();

    lastSeletedDate = now;
    String formattedDate = formatter.format(now);
    dateController.text = formattedDate;
  }

  MaterialColor getRandomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  void showPickDate() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height*0.25,
          color: Colors.white,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            onDateTimeChanged: (value) {
              dateController.text = formatter.format(value);
              lastSeletedDate = value;
            },
            initialDateTime: lastSeletedDate,
          ),
        );
      }
    );
  }

  addTransaction() {
    Navigator.pop(context);
    setState(() {
      if (titleController.text.isEmpty || amountController.text.isEmpty) return;
      var randomColor = getRandomColor();
      var newItem = TransactionItem(titleController.text,
          double.parse(amountController.text.toString()),
          dateController.text, randomColor);
      items.add(newItem);
    });

    titleController.text = "";
    amountController.text = "";
  }

  deleteTransaction(int itemIndex) {
    setState(() {
      items.removeAt(itemIndex);
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
                      onPressed: () {showPickDate();},
                      icon: const Icon(Icons.date_range),
                    ),
                    readOnly: true,
                    placeholder: "Date",
                    keyboardType: TextInputType.datetime,
                    controller: dateController,
                    onTap: () {showPickDate();},
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
    for (var value in items) {
      data.add(FlSpot(index, value.amount));
      index++;
    }
    return Chart(items: items, data: data);
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
                child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          elevation: 2,
                          child: ListTile(
                            leading: Container(
                              margin: const EdgeInsets.all(1.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: items[index].amountColor)
                              ),
                              child: Text("\$" +
                                  items[index].amount.toString(),
                                style: TextStyle(
                                    color: items[index].amountColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(items[index].title,
                                style: const TextStyle(fontSize: 20)),
                            subtitle: Text(items[index].date,
                              style: const TextStyle(fontSize: 14),),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () {
                                deleteTransaction(index);
                              },),
                          )
                      );
                    }
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
