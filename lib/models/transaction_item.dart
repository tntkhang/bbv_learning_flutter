import 'package:flutter/material.dart';
import 'package:material_color_gen/material_color_gen.dart';

class TransactionItem {
  String title = "";
  double amount = 0;
  String date = "";
  MaterialColor amountColor = const Color(0xFF2929FF).toMaterialColor();

  TransactionItem(this.title, this.amount, this.date, this.amountColor);

}