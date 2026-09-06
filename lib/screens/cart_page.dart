import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app.dart';
import '../widgets/product_image.dart';
import '../widgets/shop_app_bar.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    return Scaffold(
      appBar: const ShopAppBar(showBack: true, showCart: false),
      body: cart.lines.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 800;
                final items = ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cart.lines.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final line = cart.lines[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 76,
                              height: 96,
                              child: ProductImage(product: line.product),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(line.product.name, style: Theme.of(context).textTheme.titleMedium),
                                  const SizedBox(height: 4),
                                  Text(line.product.genre, style: Theme.of(context).textTheme.labelSmall),
                                  const SizedBox(height: 10),
                                  Text('\$${line.subtotal.toStringAsFixed(2)}'),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Decrease quantity',
                                  onPressed: () => cart.decrease(line.product),
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text('${line.quantity}'),
                                IconButton(
                                  tooltip: 'Increase quantity',
                                  onPressed: () => cart.add(line.product),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

                final summary = Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Order summary', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Items'),
                            Text('${cart.itemCount}'),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total', style: Theme.of(context).textTheme.titleMedium),
                            Text('\$${cart.total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                        const SizedBox(height: 18),
                        FilledButton(
                          onPressed: () => context.push('/checkout'),
                          child: const Text('Continue to checkout'),
                        ),
                      ],
                    ),
                  ),
                );

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: wide
                      ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: items), const SizedBox(width: 24), SizedBox(width: 300, child: summary)])
                      : Column(children: [items, const SizedBox(height: 20), summary]),
                );
              },
            ),
    );
  }
}