import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: product.accent,
      child: SizedBox.expand(
        child: Image.asset(
          product.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.image_outlined,
            size: 54,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .35),
          ),
        ),
      ),
    );
  }
}
