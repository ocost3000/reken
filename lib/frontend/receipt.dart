import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:reken/backend/currencies.dart';
import 'package:reken/backend/receipt_item.dart';

class ReceiptArgs {
  LinkedHashMap<String, ReceiptItem> items;
  final Fixed taxRate;
  final Fixed gratuityRate;
  final Currency coin;

  ReceiptArgs(this.items, this.taxRate, this.gratuityRate, this.coin);
}

class Receipt extends StatelessWidget {
  const Receipt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ReceiptArgs;

    final total = ReceiptItem.getTotal(args.items.values, args.coin);
    final taxTotal =
        args.items.values.fold(args.coin.parse("0"), (Money prev, curr) {
      final newCost = curr.price.multiplyByFixed(args.taxRate);
      return (prev + newCost);
    });

    late final tipPortion;
    if (args.items.length == 0) {
      tipPortion = args.coin.parse("0");
    } else {
      tipPortion =
          (taxTotal.multiplyByFixed(args.gratuityRate)) / args.items.length;
    }

    List<DataRow> receiptRows = args.items.values
        .map((item) => item.toReceiptRow(args.taxRate, tipPortion))
        .toList();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Receipt"),
        ),
        body: DataTable(columns: const <DataColumn>[
          DataColumn(label: Text("Name")),
          DataColumn(label: Text("Item")),
          DataColumn(label: Text("Price")),
          DataColumn(label: Text("Tax + Tip")),
        ], rows: receiptRows));
  }
}
