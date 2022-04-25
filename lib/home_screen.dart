import 'dart:developer';
import 'dart:math';

import 'package:bbv_learning_flutter/transaction_item.dart';
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
  @override
  Widget build(BuildContext context) {

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    dateController.text = formattedDate;


    MaterialColor getRandomColor() {
      return Colors.primaries[Random().nextInt(Colors.primaries.length)];
    }

    showPickDate() {}

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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(15.0)
          )
        ),
        builder: (context) => Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            margin: new EdgeInsets.all(40),
            child: Wrap(
              children: [
                Align(
                    alignment: Alignment.center,
                    child: Text("Add Transaction", style: TextStyle(fontSize: 30))),
                SizedBox(height: 50,),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Name"
                  ),
                  keyboardType: TextInputType.text,
                  controller: titleController,
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Amount"
                  ),
                  keyboardType: TextInputType.number,
                  controller: amountController,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Date",
                    suffixIcon: IconButton(
                      onPressed: showPickDate(),
                      icon: Icon(Icons.date_range),
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  controller: dateController,
                ),
                Container(
                  margin: new EdgeInsets.only(top: 30),
                  child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(onPressed: addTransaction, child: Text("Add"))),
                )
              ],
            ),
          )
        )
      );
    }

    Widget _buildChart() {
      return Container(
          margin: new EdgeInsets.all(10),
          child: const Card(
            elevation: 5,
            child: Center(
                child: Text(
                    'Chart',
                    style: TextStyle(fontSize: 30)
                )
            ),
          )
      );
    }

    Widget _buildTransactionList() {
      return items.isNotEmpty ? Container(
          margin: new EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
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
                                  style: TextStyle(fontSize: 20)),
                              subtitle: Text(items[index].date,
                                style: TextStyle(fontSize: 14),),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
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
      ) : Center(child: Text("No transaction added yet"));
    }

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: () {showBottomSheetAddTransaction();},
            child: Text('ADD', style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18),),
          ),
        ],
        title: Text('My App'),
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
