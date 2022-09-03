import 'package:flutter/rendering.dart';
import 'package:money2/money2.dart';

class ReceiptItem {
  String personName;
  String itemName;
  late Money price;

  ReceiptItem(this.personName, this.itemName, String priceStr, Currency coin) {
    price = Money.parse(priceStr, code: coin.code);
  }
}
