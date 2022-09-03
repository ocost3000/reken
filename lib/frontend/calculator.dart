import 'package:flutter/material.dart';
import 'package:money2/money2.dart';
import 'package:reken/backend/currencies.dart';

class Calculator extends StatelessWidget {
  const Calculator({Key? key}) : super(key: key);

  Future<void> _addPrompt(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              content: Container(
                height: 170,
                child: Column(children: <Widget>[
                  const Text('Add a field to receipt'),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Name"),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(hintText: "Item"),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: TextFormField(
                          decoration: const InputDecoration(hintText: "Price"),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                      ),
                      const Spacer(),
                      DropdownButton<Currency>(
                          value: commonCurrencies.usd,
                          // icon: const Icon(Icons.attach_money),
                          elevation: 16,
                          underline: Container(
                            height: 1,
                            color: Colors.grey,
                          ),
                          iconEnabledColor: Colors.deepOrange,
                          isDense: true,
                          items: dropdownCurrencies,
                          onChanged: (coin) => {})
                    ],
                  )
                ]),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: const Text('Cancel')),
                TextButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: const Text('OK')),
              ],
            ));
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
            ElevatedButton(
                onPressed: () => _addPrompt(context), child: const Text("Add")),
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
