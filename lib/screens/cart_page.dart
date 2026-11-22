import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/cart_provider.dart';
import '../widgets/shop_app_bar.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final total = cart.fold<double>(
      0,
      (sum, line) => sum + line.product.price * line.quantity,
    );
    return Scaffold(
      appBar: const ShopAppBar(showBack: true),
      body: cart.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Cart', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                for (final line in cart)
                  Card(
                    child: ListTile(
                      title: Text(line.product.name),
                      subtitle: Text(
                        '₱${line.product.price.toStringAsFixed(2)} each',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => ref
                                .read(cartProvider.notifier)
                                .setQuantity(
                                  line.product.id,
                                  line.quantity - 1,
                                ),
                            icon: const Icon(Icons.remove),
                          ),
                          Text('${line.quantity}'),
                          IconButton(
                            onPressed: () => ref
                                .read(cartProvider.notifier)
                                .setQuantity(
                                  line.product.id,
                                  line.quantity + 1,
                                ),
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text('Total: ₱${total.toStringAsFixed(2)}'),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () async {
                    try {
                      final orderId = await ref
                          .read(cartProvider.notifier)
                          .checkout();
                      if (context.mounted) {
                        await showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Order placed'),
                            content: Text(
                              'Order #$orderId was completed successfully.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Continue shopping'),
                              ),
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.go('/orders');
                                },
                                child: const Text('View orders'),
                              ),
                            ],
                          ),
                        );
                      }
                    } catch (error) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())),
                        );
                      }
                    }
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ),
    );
  }
}
