import 'package:flutter/material.dart';
import 'package:money2/money2.dart';

final commonCurrencies = CommonCurrencies();
final sgd = Currency.create('SGD', 2,
    symbol: r"S$",
    country: "Singapore",
    unit: "Dollar",
    name: "Singaporean Dollar");
final currencies = [
  commonCurrencies.aud,
  commonCurrencies.cad,
  commonCurrencies.euro,
  commonCurrencies.gbp,
  commonCurrencies.jpy,
  commonCurrencies.krw,
  commonCurrencies.mxn,
  sgd,
  commonCurrencies.usd,
];

final dropdownCurrencies =
    currencies.map<DropdownMenuItem<Currency>>((Currency coin) {
  return DropdownMenuItem<Currency>(value: coin, child: Text(coin.code));
}).toList();

dynamic validateMoneyInput(String? input, Currency coin) {
  if (input == null || input.isEmpty) {
    return "Please input the price";
  }
  List<String> inputSplit = input.split(".");
  int patternLength = inputSplit.length > 1 ? inputSplit[1].length : 0;

  if (patternLength > coin.scale) {
    return "$patternLength decimal points, but ${coin.name} only supports ${coin.scale}";
  }

  return null;
}
