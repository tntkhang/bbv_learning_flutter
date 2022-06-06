import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:material_color_gen/material_color_gen.dart';
import 'package:bbv_learning_flutter/extensions/string_extension.dart';

class TransactionItem {
  String id = '';
  String title = '';
  double amount = 0;
  String description = '';
  DateTime date = DateTime.now();
  MaterialColor amountColor = const Color(0xFF2929FF).toMaterialColor();
  String? firestoreId = '';

  TransactionItem(this.id, this.title, this.amount, this.date, this.amountColor, this.description, [this.firestoreId]);

  update(TransactionItem item) {
    title = item.title;
    amount = item.amount;
    description = item.description;
    date = item.date;
    amountColor = item.amountColor;
    firestoreId = item.firestoreId;
  }

  Map<String, dynamic> toFirestore() => {
      "fields": {
        "id": {
          "stringValue": id
        },
        "datetime": {
          "stringValue": date.toString()
        },
        "amount": {
          "integerValue": amount
        },
        "name": {
          "stringValue": title
        },
        "description": {
          "stringValue": description
        },
        "amountColor": {
          "integerValue": amountColor.value
        }
      }
    };

  factory TransactionItem.fromFireStore(Map<String, dynamic> json) {
    var name = json['name'].toString();
    var fireStoreId = name.substring(name.lastIndexOf('/') + 1).toString();
    var fields = json['fields'];
    return TransactionItem(
      fields["id"]["stringValue"],
      fields["name"]["stringValue"],
      double.parse(fields["amount"]["integerValue"]),
      fields["datetime"]["stringValue"].toString().toDate(),
      MaterialColor(int.parse(fields["amountColor"]["integerValue"]), const <int, Color>{}),
      fields["description"]["stringValue"],
      fireStoreId
    );
  }
}