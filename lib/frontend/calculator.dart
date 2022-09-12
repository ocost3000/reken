import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _taxRateInput = TextEditingController();
  final _gratuityRateInput = TextEditingController();
  Fixed _taxRate = Fixed.fromInt(0);
  Fixed _gratuityRate = Fixed.fromInt(0);
  final _mainFormKey = GlobalKey<FormState>();
  // For now total will only be in USD
  Currency _finalCurrency = commonCurrencies.usd;
  late Money _totalCost = _finalCurrency.parse("0");

  void _setTotalCost() {
    setState(() {
      _totalCost = ReceiptItem.getTotal(_items.values, _finalCurrency);
    });
  }

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

  static final List<TextInputFormatter> _percentFormatters =
      <TextInputFormatter>[
    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
    TextInputFormatter.withFunction((oldValue, newValue) {
      final double? newNum = double.tryParse(newValue.text);
      if (newNum == null) {
        return oldValue;
      }
      return newValue;
    })
  ];

  static String? _validateStringTextFormField(String? value, String emptyMsg) {
    if (value == null || value.isEmpty) {
      return emptyMsg;
    }
    return null;
  }

  String? _validatePercentTextFormField(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    double? valueDouble = double.tryParse(value);
    if (valueDouble == null) {
      return "Not a valid percentage";
    }
    return null;
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
                        const BoxConstraints(minHeight: 170, maxHeight: 250),
                    child: Column(children: <Widget>[
                      const Text('Add a field to receipt'),
                      TextFormField(
                        validator: (value) => _validateStringTextFormField(
                            value, "Please specify the name for the person"),
                        decoration: const InputDecoration(
                            hintText: "Person", errorMaxLines: 3),
                        controller: person,
                      ),
                      TextFormField(
                        validator: (value) => _validateStringTextFormField(
                            value, "Please specify an item name"),
                        decoration: const InputDecoration(
                            hintText: "Item", errorMaxLines: 3),
                        controller: itemName,
                      ),
                      Row(
                        children: [
                          SizedBox(
                              width: 150,
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"[0-9.]"))
                                ],
                                validator: (value) =>
                                    ReceiptItem.validateMoneyInput(value, coin),
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
                        _setTotalCost();
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
      body: Form(
        key: _mainFormKey,
        child: Container(
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
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Column(children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            validator: (value) =>
                                _validatePercentTextFormField(value),
                            controller: _taxRateInput,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                                hintText: "Tax Rate % (ex. '8.75')"),
                            inputFormatters: _percentFormatters,
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                              validator: (value) =>
                                  _validatePercentTextFormField(value),
                              controller: _gratuityRateInput,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                  hintText: "Gratuity/Tip % (ex. '12')"),
                              inputFormatters: _percentFormatters),
                        ),
                      ]),
                      const SizedBox(
                        width: 30,
                      ),
                      FloatingActionButton(
                        heroTag: "RefreshRates",
                        splashColor: Theme.of(context).splashColor,
                        child: const Icon(Icons.refresh),
                        onPressed: () {
                          if (_mainFormKey.currentState!.validate()) {
                            final taxRateCheck = _taxRateInput.text == ""
                                ? "0"
                                : _taxRateInput.text;
                            final taxRate = Fixed.fromNum(
                                double.parse(taxRateCheck) / 100,
                                scale: 2);
                            final gratuityRateCheck =
                                _gratuityRateInput.text == ""
                                    ? "0"
                                    : _gratuityRateInput.text;
                            final gratuityRate = Fixed.fromNum(
                                double.parse(gratuityRateCheck) / 100,
                                scale: 2);
                            setState(() {
                              _taxRate = taxRate;
                              _gratuityRate = gratuityRate;
                            });
                          }
                        },
                      )
                    ]),
                    const Spacer(),
                    IntrinsicWidth(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.5,
                              color: Colors.blue,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Subtotal: ",
                                  textScaleFactor: 1.3,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  _totalCost.toString(),
                                  textScaleFactor: 1.3,
                                ),
                              ]),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 70,
                    )
                  ]),
            )),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton(
              heroTag: "GenerateReceipt",
              onPressed: () => Navigator.pushNamed(context, '/receipt',
                  arguments: ReceiptArgs(
                      _items, _taxRate, _gratuityRate, _finalCurrency)),
              child: const Icon(Icons.calculate)),
        ]),
      ),
    );
  }
}
