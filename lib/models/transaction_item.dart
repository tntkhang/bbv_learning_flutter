import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:material_color_gen/material_color_gen.dart';


List<TransactionItem> listTransFromJson(String str) => List<TransactionItem>.from(json.decode(str).map((x) => TransactionItem.fromJson(x)));

String listTransToJson(List<TransactionItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
  factory TransactionItem.fromJson(Map<String, dynamic> json) => TransactionItem(
    json["id"],
    json["title"],
    json["amount"],
    json["date"],
    json["amountColor"],
    json["description"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "id": id,
    "title": title,
    "description": description,
    "date": date,
    "amountColor": amountColor,
  };

  toString() {
    return "id: " + id +
        ", title: " + title +
        ", amount: " + amount.toString() +
        ", description: " + description +
        ", date: " + date.toString() +
        ", amountColor: " + amountColor.value.toString();
  }
  Map<String, dynamic> toFirestore() => {
      "fields": {
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
}