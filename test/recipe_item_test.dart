import 'dart:js_util';

import 'package:money2/money2.dart';
import 'package:reken/backend/currencies.dart';
import 'package:reken/backend/receipt_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Validate RecipeItem constructor', () {
    String name = "Omar";
    String item = "Chicken Chalupa";
    String priceStr = "12.9";
    Currency coin = commonCurrencies.usd;
    Money testMoney = Money.parse(priceStr, code: coin.code);
    expect(r"$12.90", equals(testMoney.toString()));
  });
}
