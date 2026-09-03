import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/shop_app_bar.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ShopAppBar(showBack: true),
      body: SizedBox.shrink(),
    );
  }
}
