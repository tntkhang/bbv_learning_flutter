import 'dart:math';

import 'package:bbv_learning_flutter/extensions/date_extension.dart';
import 'package:bbv_learning_flutter/models/transaction_item.dart';
import 'package:bbv_learning_flutter/screens/setting_screen.dart';
import 'package:bbv_learning_flutter/screens/transaction_detail.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
final desController = TextEditingController();
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
            lastSelectedDate, randomColor, desController.text);
        items.add(newItem);
        items.sort((from, to) => from.date.compareTo(to.date));
      });
      Navigator.pop(context);

      titleController.text = '';
      amountController.text = '';
      desController.text = '';
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
                  PlatformTextField(
                    hintText: "Name",
                    keyboardType: TextInputType.text,
                    controller: titleController,
                  ),
                  const SizedBox(height: 40,),
                  PlatformTextField(
                    hintText: "Amount",
                    keyboardType: TextInputType.number,
                    controller: amountController,
                  ),
                  const SizedBox(height: 40,),
                  PlatformTextField(
                    hintText: "Description",
                    keyboardType: TextInputType.text,
                    controller: desController,
                    minLines: 5,
                    maxLines: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child:  CupertinoTextField(
                      suffix: IconButton(
                        onPressed: () {_showDatePicker();},
                        icon: const Icon(Icons.date_range),
                      ),
                      readOnly: true,
                      keyboardType: TextInputType.datetime,
                      controller: dateController,
                      onTap: () {_showDatePicker();},
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Align(
                        alignment: Alignment.center,
                        child: PlatformTextButton(onPressed: addTransaction, child: const Text("Add"))),
                  )
                ],
              ),
            )
        )
    );
  }

  _goToDetailScreen(TransactionItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TransactionDetailScreen(transactionTitle: item.title, transactionDes: item.description,)),
    );
  }

  _goToHomeScreen() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  _goToSettingScreen() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingScreen()),
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
            const SizedBox(height: 16,),
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
                    elevation: 8,
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
                      onTap: () {
                        _goToDetailScreen(element as TransactionItem);
                      },
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
    return PlatformScaffold(
      appBar: PlatformAppBar(
        trailingActions: <Widget>[
          PlatformTextButton(
            onPressed: () {showBottomSheetAddTransaction();},
            child: PlatformText('ADD', style: const TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15),),
          ),
        ],
        title: PlatformText('My App'),
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
      material: (_, __)  => MaterialScaffoldData(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Center(child: Text('Expense Notes')),
              ),
              ListTile(
                title: const Center(child: Text('Home')),
                onTap: () {
                  _goToHomeScreen();
                },
              ),
              ListTile(
                title: const Center(child: Text('Settings')),
                onTap: () {
                  _goToSettingScreen();
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showBottomSheetAddTransaction();
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
      )
    );
  }
}
