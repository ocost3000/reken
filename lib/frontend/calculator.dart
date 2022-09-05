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

  double _resolveWidthFactor(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double widthFactor = -9.0;

    if (width < 500.0) {
      widthFactor = 0.9;
    } else {
      widthFactor = 0.7;
    }

    return widthFactor;
  }

  List<DataRow> _getRows() =>
      _items.values.map((item) => item.toRow()).toList();

  Future<void> _addPrompt(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (context) {
          final person = TextEditingController();
          final itemName = TextEditingController();
          final priceInput = TextEditingController();
          Currency coin = commonCurrencies.usd;

          final dialogKey = GlobalKey<FormState>();

          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              content: Form(
                key: dialogKey,
                // for defaulting to minHeight
                child: IntrinsicHeight(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(minHeight: 170, maxHeight: 230),
                    child: Column(children: <Widget>[
                      const Text('Add a field to receipt'),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please specify a name for the person";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: "Person", errorMaxLines: 3),
                        controller: person,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please specify an item name";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: "Item", errorMaxLines: 3),
                        controller: itemName,
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: 150,
                              child: TextFormField(
                                validator: (value) =>
                                    validateMoneyInput(value, coin),
                                decoration: const InputDecoration(
                                    hintText: "Price", errorMaxLines: 3),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                controller: priceInput,
                              )),
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
                              onChanged: (value) =>
                                  setState(() => coin = value!))
                        ],
                      )
                    ]),
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () {
                      if (dialogKey.currentState!.validate()) {
                        Money price = coin.parse(priceInput.text);
                        var newItem = ReceiptItem(
                            person.text, itemName.text, price, _removeItem);
                        _addItem(newItem);
                        Navigator.of(context).pop();
                      }
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
          child: FractionallySizedBox(
            widthFactor: _resolveWidthFactor(context),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DataTable(columns: const <DataColumn>[
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Item")),
                    DataColumn(label: Text("Price")),
                    DataColumn(label: Text(""))
                  ], rows: _getRows()),
                  ElevatedButton(
                      onPressed: () => _addPrompt(context),
                      child: const Text("Add Item")),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Tax Rate % (ex. '8.75')")),
                  ),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Gratuity/Tip % (ex. '12')")),
                  ),
                  const Spacer(),
                ]),
          )),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
            onPressed: () => Navigator.pushNamed(context, '/receipt'),
            child: const Icon(Icons.calculate)),
      ),
    );
  }
}
