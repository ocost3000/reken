import 'package:flutter/material.dart';
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

  DataRow toReceiptRow(Fixed tax, Money tipRise) {
    final Money afterTax = price + price.multiplyByFixed(tax);
    final Money afterTip = afterTax + tipRise;
    return DataRow(cells: <DataCell>[
      DataCell(Text(person)),
      DataCell(Text(itemName)),
      DataCell(Text(price.toString())),
      DataCell(Text(afterTip.toString())),
    ]);
  }

  Money applyPercent(String percent) {
    List<String> decimalSplit = percent.split(".");
    int decimalLength = decimalSplit.length > 1 ? decimalSplit[1].length : 0;
    Fixed fixedValue = Fixed.fromNum(
      double.tryParse(percent)!,
    );
    return price;
  }

  static String? validateMoneyInput(String? input, Currency coin) {
    if (input == null || input.isEmpty) {
      return "Please input the price";
    }
    try {
      final newVal = coin.parse(input);
      debugPrint(newVal.toString());
    } on FormatException {
      return "Invalid format for ${coin.name}";
    }

    return null;
  }

  static Money getTotal(Iterable<ReceiptItem> items, Currency coin) {
    Money runningTotal = coin.parse('0');
    items.forEach((item) {
      runningTotal += item.price;
    });
    return runningTotal;
  }
}
