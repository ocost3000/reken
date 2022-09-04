import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:reken/backend/currencies.dart';
import 'package:reken/backend/receipt_item.dart';
import 'package:reken/frontend/receipt.dart';

class Calculator extends StatefulWidget {
  const Calculator({Key? key}) : super(key: key);

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  LinkedHashMap<String, ReceiptItem> _items = LinkedHashMap();

  void _removeItem(String id) => setState(() => _items.remove(id));

  void _addItem(ReceiptItem item) => setState(() => _items[item.id] = item);

  List<DataRow> _getRows() =>
      _items.values.map((item) => item.toRow()).toList();

  Future<void> _addPrompt(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          String person = "";
          String itemName = "";
          String priceInput = "";
          Currency coin = commonCurrencies.usd;

          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              content: Container(
                height: 170,
                child: Column(children: <Widget>[
                  const Text('Add a field to receipt'),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Person"),
                    onChanged: (value) => setState(() => person = value),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Item"),
                    onChanged: (value) => setState(() => itemName = value),
                  ),
                  Row(
                    children: [
                      SizedBox(
                          width: 150,
                          child: TextFormField(
                              decoration:
                                  const InputDecoration(hintText: "Price"),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              onChanged: (value) =>
                                  setState(() => priceInput = value))),
                      const Spacer(),
                      DropdownButton<Currency>(
                          value: coin,
                          // icon: const Icon(Icons.attach_money),
                          elevation: 16,
                          underline: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          iconEnabledColor: Colors.deepOrange,
                          isDense: true,
                          items: dropdownCurrencies,
                          onChanged: (value) => setState(() => coin = value!))
                    ],
                  )
                ]),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      Money price = Money.parse(priceInput, code: coin.code);
                      var newItem =
                          ReceiptItem(person, itemName, price, _removeItem);
                      _addItem(newItem);
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK')),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Receipt")),
      body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            DataTable(columns: const <DataColumn>[
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Item")),
              DataColumn(label: Text("Price")),
              DataColumn(label: Text(""))
            ], rows: _getRows()),
            ElevatedButton(
                onPressed: () => _addPrompt(context),
                child: const Text("Add Item")),
            const Spacer(),
          ])),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/receipt'),
            child: const Icon(Icons.calculate)),
      ),
    );
  }
}
