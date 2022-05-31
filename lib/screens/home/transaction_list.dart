import 'package:bbv_learning_flutter/extensions/date_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

import '../../models/transaction_item.dart';

class TransactionList extends StatelessWidget {
  ValueChanged<TransactionItem> showBottomSheet;
  ValueChanged<TransactionItem> deleteItem;
  ValueChanged<TransactionItem> editItem;
  ValueChanged<TransactionItem> gotoItemDetail;
  List<TransactionItem> items = [];

  TransactionList({Key? key,
    required this.showBottomSheet,
    required this.deleteItem,
    required this.editItem,
    required this.gotoItemDetail,
    required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                                  showBottomSheet(element);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  deleteItem(element);
                                },
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          gotoItemDetail(element as TransactionItem);
                        },
                      )),
                  order: GroupedListOrder.ASC,
                ))
          ],
        ))
        : const Center(child: Text("No transaction added yet"));
  }
}
