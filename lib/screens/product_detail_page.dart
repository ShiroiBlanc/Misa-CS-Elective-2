import 'package:flutter/material.dart';

import '../models/product.dart';
import '../app.dart';
import '../theme/app_theme.dart';
import '../widgets/shop_app_bar.dart';
import '../widgets/product_image.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    return Scaffold(
      appBar: const ShopAppBar(showBack: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= tabletBreakpoint;
          final cover = AspectRatio(
            aspectRatio: .8,
            child: ProductImage(product: product),
          );
          final details = <Widget>[
            Text(product.name, style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 8),
            Text(product.genre, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 18),
            Text(
              productSynopsis[product.id] ??
                  'Enter a richly imagined world of martial arts, cultivation, and legendary heroes.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 22),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                cart.add(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Book added to cart')),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add to cart'),
            ),
          ];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: cover),
                      const SizedBox(width: 40),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: details,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [cover, const SizedBox(height: 24), ...details],
                  ),
          );
        },
      ),
    );
  }
}
