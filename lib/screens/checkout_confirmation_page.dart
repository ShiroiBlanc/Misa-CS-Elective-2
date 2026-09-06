import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app.dart';
import '../widgets/shop_app_bar.dart';

class CheckoutConfirmationPage extends StatelessWidget {
  const CheckoutConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    return Scaffold(
      appBar: const ShopAppBar(showBack: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.check_circle_outline, size: 58, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 16),
                    Text('Checkout confirmation', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    const Text('Review your selected books before confirming.', textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    ...cart.lines.map(
                      (line) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('${line.product.name} x${line.quantity}')),
                            Text('\$${line.subtotal.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: Theme.of(context).textTheme.titleMedium),
                        Text('\$${cart.total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: cart.lines.isEmpty
                          ? null
                          : () {
                              cart.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Order confirmed')),
                              );
                              context.go('/');
                            },
                      child: const Text('Confirm order'),
                    ),
                    TextButton(
                      onPressed: () => context.go('/cart'),
                      child: const Text('Back to cart'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}