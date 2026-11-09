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
        child: product.imageUrl == null
            ? Icon(
                Icons.menu_book_rounded,
                size: 54,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: .35),
              )
            : product.imageUrl!.startsWith('http')
            ? Image.network(
                product.imageUrl!,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                errorBuilder: (context, error, stackTrace) =>
                    _fallbackImage(context),
              )
            : Image.asset(
                product.localImageUrl ?? product.imageUrl!,
                fit: BoxFit.cover,
                gaplessPlayback: true,
                errorBuilder: (context, error, stackTrace) =>
                    _fallbackImage(context),
              ),
      ),
    );
  }

  Widget _fallbackImage(BuildContext context) {
    if (product.localImageUrl != null) {
      return Image.asset(
        product.localImageUrl!,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) => _bookIcon(context),
      );
    }
    return _bookIcon(context);
  }

  Widget _bookIcon(BuildContext context) => Icon(
    Icons.menu_book_rounded,
    size: 54,
    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: .35),
  );
}
