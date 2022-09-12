import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
