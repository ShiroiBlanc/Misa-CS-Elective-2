import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';
import '../models/product.dart';

class CartLine {
  const CartLine({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  CartLine copyWith({int? quantity}) =>
      CartLine(product: product, quantity: quantity ?? this.quantity);
}

final cartProvider = NotifierProvider<CartNotifier, List<CartLine>>(
  CartNotifier.new,
);

class CartNotifier extends Notifier<List<CartLine>> {
  @override
  List<CartLine> build() => const [];

  void add(Product product) {
    if (product.stock <= 0) return;
    final index = state.indexWhere((line) => line.product.id == product.id);
    if (index == -1) {
      state = [...state, CartLine(product: product, quantity: 1)];
    } else {
      final lines = [...state];
      final line = lines[index];
      if (line.quantity < line.product.stock) {
        lines[index] = line.copyWith(quantity: line.quantity + 1);
      }
      state = lines;
    }
  }

  void setQuantity(String productId, int quantity) {
    final index = state.indexWhere((line) => line.product.id == productId);
    if (index == -1) return;
    final productLine = state[index];
    final clampedQuantity = quantity > productLine.product.stock
        ? productLine.product.stock
        : quantity;
    if (clampedQuantity <= 0) {
      remove(productId);
      return;
    }
    state = [
      for (final line in state)
        line.product.id == productId
            ? line.copyWith(quantity: clampedQuantity)
            : line,
    ];
  }

  void remove(String productId) =>
      state = state.where((line) => line.product.id != productId).toList();

  Future<int> checkout() async {
    if (state.isEmpty) throw Exception('Cart is empty.');
    if (state.any((line) => line.product.id.startsWith('local-'))) {
      throw Exception(
        'A local sample product cannot be checked out. Reload the catalog.',
      );
    }
    final orderId = await supabase.rpc(
      'checkout_order',
      params: {
        'p_items': [
          for (final line in state)
            {
              'product_id': int.parse(line.product.id),
              'quantity': line.quantity,
            },
        ],
      },
    );
    state = const [];
    return (orderId as num).toInt();
  }
}
