import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:money2/money2.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class ReceiptItem {
  late final String _id;
  String person;
  String itemName;
  late Money price;
  final void Function(String) remove;

  ReceiptItem(this.person, this.itemName, this.price, this.remove) {
    _id = uuid.v4();
  }

  String get id => _id;

  DataRow toRow() => DataRow(cells: <DataCell>[
        DataCell(Text(person)),
        DataCell(Text(itemName)),
        DataCell(Text(price.toString())),
        DataCell(IconButton(
            onPressed: () => remove(id), icon: const Icon(Icons.remove_circle)))
      ]);
}
