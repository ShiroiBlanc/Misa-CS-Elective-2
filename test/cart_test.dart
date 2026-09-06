import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:cs_elective_2/models/cart.dart';
import 'package:cs_elective_2/models/product.dart';

void main() {
  const product = Product(
    id: 1,
    name: 'Test Novel',
    genre: 'Xianxia',
    price: 4.99,
    imageUrl: 'assets/covers/coiling_dragon.webp',
    accent: Color(0xFFFFFFFF),
  );

  test('cart updates quantities, subtotals, and totals', () {
    final cart = Cart();

    cart.add(product);
    cart.add(product);

    expect(cart.itemCount, 2);
    expect(cart.lines.single.quantity, 2);
    expect(cart.lines.single.subtotal, closeTo(9.98, 0.001));
    expect(cart.total, closeTo(9.98, 0.001));

    cart.decrease(product);
    expect(cart.itemCount, 1);
    expect(cart.lines.single.quantity, 1);

    cart.remove(product);
    expect(cart.lines, isEmpty);
    expect(cart.total, 0);
  });
}
