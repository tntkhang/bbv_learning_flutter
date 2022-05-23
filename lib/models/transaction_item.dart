import 'package:flutter/material.dart';
import 'package:material_color_gen/material_color_gen.dart';

class TransactionItem {
  String id = '';
  String title = '';
  double amount = 0;
  String description = '';
  DateTime date = DateTime.now();
  MaterialColor amountColor = const Color(0xFF2929FF).toMaterialColor();

  TransactionItem(this.id, this.title, this.amount, this.date, this.amountColor, this.description);

  update(TransactionItem item) {
    title = item.title;
    amount = item.amount;
    description = item.description;
    date = item.date;
    amountColor = item.amountColor;
  }
}