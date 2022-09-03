import 'dart:isolate';

import 'package:money2/money2.dart';
import 'package:reken/backend/currencies.dart';
import 'package:reken/backend/recipe_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Validate RecipeItem constructor', () {
    String name = "Omar";
    String item = "Chicken Chalupa";
    String priceStr = "12.99";
    Currency coin = commonCurrencies.usd;

    ReceiptItem recItem = ReceiptItem(name, item, priceStr, coin);

    Money price = Money.parse(priceStr, code: coin.code);

    expect(recItem.price, equals(price));
  });
}
