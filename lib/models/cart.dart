import 'package:flutter/foundation.dart';

import 'product.dart';

class CartLine {
  CartLine({required this.product, this.quantity = 1});

  final Product product;
  int quantity;

  double get subtotal => product.price * quantity;
}

class Cart extends ChangeNotifier {
  final List<CartLine> _lines = [];

  List<CartLine> get lines => List.unmodifiable(_lines);

  int get itemCount => _lines.fold(0, (total, line) => total + line.quantity);

  double get total => _lines.fold(0, (sum, line) => sum + line.subtotal);

  void add(Product product) {
    final existing = _lines.where((line) => line.product.id == product.id);
    if (existing.isNotEmpty) {
      existing.first.quantity++;
    } else {
      _lines.add(CartLine(product: product));
    }
    notifyListeners();
  }

  void decrease(Product product) {
    final line = _lineFor(product);
    if (line == null) return;
    if (line.quantity == 1) {
      _lines.remove(line);
    } else {
      line.quantity--;
    }
    notifyListeners();
  }

  void remove(Product product) {
    _lines.removeWhere((line) => line.product.id == product.id);
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }

  CartLine? _lineFor(Product product) {
    for (final line in _lines) {
      if (line.product.id == product.id) return line;
    }
    return null;
  }
}