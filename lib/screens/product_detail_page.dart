import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';
import '../widgets/shop_app_bar.dart';
import '../widgets/product_image.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(
      FutureProvider<Product>((ref) {
        return ref.read(productRepositoryProvider).fetchProduct(productId);
      }).future,
    );
    return Scaffold(
      appBar: const ShopAppBar(showBack: true),
      body: FutureBuilder<Product>(
        future: product,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text('Unable to load this book: ${snapshot.error}'),
            );
          }
          final item = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              SizedBox(height: 360, child: ProductImage(product: item)),
              const SizedBox(height: 24),
              Text(item.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                '₱${item.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text('${item.conditionLabel} · Physical book'),
              const SizedBox(height: 20),
              Text(item.description),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text('Add to cart'),
              ),
            ],
          );
        },
      ),
    );
  }
}
