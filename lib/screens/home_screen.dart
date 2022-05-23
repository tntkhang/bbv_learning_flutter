import 'dart:math';

import 'package:bbv_learning_flutter/extensions/date_extension.dart';
import 'package:bbv_learning_flutter/extensions/string_extension.dart';
import 'package:bbv_learning_flutter/models/transaction_item.dart';
import 'package:bbv_learning_flutter/screens/setting_screen.dart';
import 'package:bbv_learning_flutter/screens/transaction_detail_screen.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../utils/screen_keys.dart';
import '../widgets/chart.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter/material.dart';

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

  // void showDatePicker() async {
  //     DateTime? temp = await showPlatformDatePicker(
  //       context: context,
  //       firstDate: DateTime(DateTime.now().year - 2),
  //       initialDate: DateTime.now(),
  //       lastDate: DateTime(DateTime.now().year + 2),
  //       builder: (context, child) => Theme(
  //         data: Theme.of(context).copyWith(
  //           primaryColor: const Color(0xFF8CE7F1),
  //           accentColor: const Color(0xFF8CE7F1),
  //           colorScheme: ColorScheme.fromSwatch(
  //             primarySwatch: Colors.purple,
  //             brightness: Theme.of(context).brightness,
  //           ),
  //         ),
  //         child: child ?? const SizedBox.shrink(),
  //       ),
  //     );
  //     if (temp != null) {
  //       setState(() => {
  //           dateController.text = temp.formatDate();
  //           lastSelectedDate = temp;
  //         }
  //       );
  //     }
  // }

  void _showDatePicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height * 0.25,
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
        });

    // DateTime? temp = await showPlatformDatePicker(
    //   context: context,
    //   firstDate: DateTime(DateTime.now().year - 2),
    //   initialDate: DateTime.now(),
    //   lastDate: DateTime(DateTime.now().year + 2),
    //   builder: (context, child) => Theme(
    //     data: Theme.of(context).copyWith(
    //       primaryColor: const Color(0xFF8CE7F1),
    //       accentColor: const Color(0xFF8CE7F1),
    //       colorScheme: ColorScheme.fromSwatch(
    //         primarySwatch: Colors.purple,
    //         brightness: Theme.of(context).brightness,
    //       ),
    //     ),
    //     child: child ?? const SizedBox.shrink(),
    //   ),
    // );
    // if (temp != null) setState(() => date = temp);
  }

  addTransaction() {
    var randomColor = _getRandomColor();
    var uuid = const Uuid();

    var newItem = TransactionItem(
        uuid.v1(),
        titleController.text,
        double.parse(amountController.text.toString()),
        lastSelectedDate,
        randomColor,
        desController.text);
    setState(() {
      items.add(newItem);
      items.sort((from, to) => from.date.compareTo(to.date));
    });
    Navigator.pop(context);
    _resetEditText();
  }

  deleteTransaction(TransactionItem itemIndex) {
    setState(() {
      items.remove(itemIndex);
    });
  }

  void _resetEditText() {
    titleController.text = '';
    amountController.text = '';
    desController.text = '';
  }

  editTransaction(String itemId, String newTitle, double newAmount,
      String newDes) {
    setState(() {
      var item = items.firstWhere((element) => element.id == itemId);
      item.title = newTitle;
      item.amount = newAmount;
      item.description = newDes;
      item.date = lastSelectedDate;
    });
    Navigator.pop(context);
    _resetEditText();
  }

  Widget _getButton([TransactionItem? item]) {
    return Align(
        alignment: Alignment.center,
        child: PlatformTextButton(
            onPressed: () => (item == null) ? addTransaction() : editTransaction(
                item.id,
                titleController.text,
                double.parse(amountController.text.toString()),
                desController.text),
            child: Text((item == null) ? 'Add' : 'Save',
                style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))));
  }

  showBottomSheetAddEditTransaction([TransactionItem? item]) {
    if (item != null) {
      titleController.text = item.title;
      amountController.text = item.amount.toString();
      desController.text = item.description;
      dateController.text = item.date.formatDate();
    }
    var title = (item == null) ? 'Add Transaction' : 'Edit Transaction';
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        builder: (context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              margin: const EdgeInsets.only(
                  left: 40.0, top: 20.0, right: 40.0, bottom: 40.0),
              child: Wrap(
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Text(title, style: const TextStyle(fontSize: 30))),
                  const SizedBox(
                    height: 50,
                  ),
                  PlatformTextField(
                    hintText: "Name",
                    keyboardType: TextInputType.text,
                    controller: titleController,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  PlatformTextField(
                    hintText: "Amount",
                    keyboardType: TextInputType.number,
                    controller: amountController,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  PlatformTextField(
                    hintText: "Description",
                    keyboardType: TextInputType.text,
                    controller: desController,
                    minLines: 3,
                    maxLines: 5,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: CupertinoTextField(
                      suffix: IconButton(
                        onPressed: () {
                          _showDatePicker();
                        },
                        icon: const Icon(Icons.date_range),
                      ),
                      readOnly: true,
                      keyboardType: TextInputType.datetime,
                      controller: dateController,
                      onTap: () {
                        _showDatePicker();
                      },
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: _getButton(item))
                ],
              ),
            )));
  }

  _goToDetailScreen(TransactionItem item) {
    Navigator.pushNamed(context, ScreenKeys.itemDetail, arguments: {
      'transactionTitle': item.title,
      'transactionDes': item.description
    });
  }

  Widget _buildChart() {
    List<FlSpot> data = [];
    double index = 0;
    double maxAmount = 0.0;

    var groupByDate = items.groupListsBy((obj) => obj.date);
    for (var value in groupByDate.keys) {
      var totalAmount = 0.0;
      groupByDate[value]?.forEach((element) {
        totalAmount += element.amount;
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
    return items.isNotEmpty
        ? Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Transaction list",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold))),
                const SizedBox(
                  height: 16,
                ),
                Expanded(
                    child: GroupedListView<dynamic, String>(
                  elements: items,
                  groupBy: (element) => (element.date as DateTime).formatDate(),
                  groupSeparatorBuilder: (String value) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  itemBuilder: (context, dynamic element) => Card(
                      elevation: 8,
                      child: ListTile(
                        leading: Container(
                          margin: const EdgeInsets.all(1.0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: element.amountColor)),
                          child: Text(
                            "\$" + element.amount.toString(),
                            style: TextStyle(
                                color: element.amountColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(element.title,
                            style: const TextStyle(fontSize: 20)),
                        subtitle: Text(
                          (element.date as DateTime).formatDate(),
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: FittedBox(
                          fit: BoxFit.fill,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  showBottomSheetAddEditTransaction(element);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  deleteTransaction(element);
                                },
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          _goToDetailScreen(element as TransactionItem);
                        },
                      )),
                  order: GroupedListOrder.ASC,
                ))
              ],
            ))
        : const Center(child: Text("No transaction added yet"));
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        trailingActions: <Widget>[
          PlatformTextButton(
            onPressed: () {
              showBottomSheetAddEditTransaction();
            },
            child: PlatformText(
              'ADD',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
        ],
        title: PlatformText('My App'),
      ),
      body: Column(
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
      material: (_, __) => MaterialScaffoldData(
        drawer: AppDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showBottomSheetAddEditTransaction();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
