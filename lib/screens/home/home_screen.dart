import 'dart:convert';
import 'dart:math';

import 'package:bbv_learning_flutter/extensions/date_extension.dart';
import 'package:bbv_learning_flutter/models/authen_model.dart';
import 'package:bbv_learning_flutter/models/transaction_item.dart';
import 'package:bbv_learning_flutter/screens/home/bottom_sheet_add_edit_transaction.dart';
import 'package:bbv_learning_flutter/screens/home/transaction_list.dart';
import 'package:bbv_learning_flutter/services/api_services.dart';
import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../utils/screen_routes.dart';
import 'chart.dart';
import '../../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TransactionItem> items = [];
  final APISerivce _apiSerivce = APISerivce();

  @override
  void initState() {
    super.initState();
    _apiSerivce.getTransactions().listen((event) {
      setState(() {
        items = event;
      });
    });
  }

  void _addTransaction(TransactionItem newItem) {
    setState(() {
      items.add(newItem);
      items.sort((from, to) => from.date.compareTo(to.date));
    });
    _apiSerivce.postTransaction(newItem).listen((event) {
      if (event is TransactionItem) {
        var item = items.firstWhereOrNull((element) => element.id == event.id);
        item?.update(event);
      }
    });
  }

  void _editTransaction(TransactionItem newItem) {
    var item = items.firstWhere((element) => element.id == newItem.id);
    setState(() {
      item.update(newItem);
    });
  }

  void _deleteTransaction(TransactionItem item) {
    setState(() {
      items.remove(item);
    });
    _apiSerivce.deleteTransaction(item).listen((event) {
      if (event == APIStatus.SUCCESS) {
        Fluttertoast.showToast(
            msg: "Delete success !",
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
        );
      }
    });
  }

  void _goToDetailScreen(TransactionItem item) {
    Navigator.pushNamed(context, ScreenRoutes.itemDetail, arguments: {
      'transactionTitle': item.title,
      'transactionDes': item.description
    });
  }

  void showBottomSheetAddEditTransaction([TransactionItem? item]) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0))),
        builder: (context) => Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: BottomSheetAddEditTransaction(
              onAddItem: (transItem) {
                // print('>>> transItem: ' + transItem.toString());
                _addTransaction(transItem);
              },
              onEditItem: (transItem) {
                _editTransaction(transItem);
              },
              transactionItem: item,
            )));
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
    return TransactionList(
      showBottomSheet: (TransactionItem value) {
        showBottomSheetAddEditTransaction(value);
      },
      deleteItem: (TransactionItem item) => {_deleteTransaction(item)},
      editItem: (TransactionItem item) => {_editTransaction(item)},
      gotoItemDetail: (TransactionItem item) => {_goToDetailScreen(item)},
      items: items,
    );
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
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
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
