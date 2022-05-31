import 'dart:math';

import 'package:bbv_learning_flutter/extensions/date_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:uuid/uuid.dart';
import '../../models/transaction_item.dart';

class BottomSheetAddEditTransaction extends StatefulWidget {
  ValueChanged<TransactionItem> onAddItem;
  ValueChanged<TransactionItem> onEditItem;
  TransactionItem? transactionItem;

  BottomSheetAddEditTransaction({
    Key? key,
    required this.onAddItem,
    required this.onEditItem,
    this.transactionItem}) : super(key: key);

  @override
  State<BottomSheetAddEditTransaction> createState() => _BottomSheetAddEditTransactionState();
}

class _BottomSheetAddEditTransactionState extends State<BottomSheetAddEditTransaction> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  var title= '';
  var selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    dateController.text = selectedDate.formatDate();
    if (widget.transactionItem != null) {
      titleController.text = widget.transactionItem?.title ?? '';
      amountController.text = widget.transactionItem?.amount.toString() ?? '';
      desController.text = widget.transactionItem?.description ?? '';
      dateController.text = widget.transactionItem?.date.formatDate() ?? selectedDate.formatDate();
    }
    title = (widget.transactionItem == null) ? 'Add Transaction' : 'Edit Transaction';
  }

  Widget _getButton([TransactionItem? item]) {
    return Align(
        alignment: Alignment.center,
        child: PlatformTextButton(
            onPressed: () => (item == null) ? _addTransaction() : _editTransaction(
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

  void _showDatePicker() async {
    DateTime? temp = await showPlatformDatePicker(
      context: context,
      firstDate: DateTime(1950),
      initialDate: selectedDate,
      lastDate: DateTime.now(),
    );

    if (temp != null) {
      dateController.text = temp.formatDate();
      selectedDate = temp;
    }
  }

  void _addTransaction() {
    var randomColor = _getRandomColor();
    var uuid = const Uuid();

    var newItem = TransactionItem(
        uuid.v1(),
        titleController.text,
        double.parse(amountController.text.toString()),
        selectedDate,
        randomColor,
        desController.text);
    widget.onAddItem(newItem);
    Navigator.pop(context);
  }

  void _editTransaction(String itemId, String newTitle, double newAmount,
      String newDes) {
    widget.transactionItem?.title = newTitle;
    widget.transactionItem?.amount = newAmount;
    widget.transactionItem?.description = newDes;
    widget.transactionItem?.date = selectedDate;

    widget.onEditItem(widget.transactionItem!);
    Navigator.pop(context);
  }

  MaterialColor _getRandomColor() {
    return Colors.primaries[Random().nextInt(Colors.primaries.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: PlatformTextField(
              readOnly: true,
              keyboardType: TextInputType.datetime,
              controller: dateController,
              onTap: () {
                _showDatePicker();
              },
              material: (_, __) => MaterialTextFieldData(
                decoration: const InputDecoration(
                  suffixIcon: Icon(Icons.date_range),
                ),
              ),
            ),
          ),
          Container(
              margin: const EdgeInsets.only(top: 20),
              child: _getButton(widget.transactionItem))
        ],
      ),
    );
  }
}
