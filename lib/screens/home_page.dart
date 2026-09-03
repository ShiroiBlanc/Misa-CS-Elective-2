import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import '../widgets/shop_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShopAppBar(),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: _HomeHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.crossAxisExtent;
                final columns = width >= desktopBreakpoint
                    ? 4
                    : width >= tabletBreakpoint
                    ? 3
                    : 2;
                return SliverGrid.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 22,
                    childAspectRatio: width < 500 ? .67 : .76,
                  ),
                  itemBuilder: (context, index) =>
                      ProductCard(product: products[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      child: LayoutBuilder(
        builder: (context, constraints) => Flex(
          direction: constraints.maxWidth < 600
              ? Axis.vertical
              : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: Text(
                'Objects with\na point of view.',
                style: TextStyle(
                  fontSize: 38,
                  height: 1.05,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth < 600 ? double.infinity : 290,
              child: const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'Thoughtful pieces for slower mornings, clearer desks, and rooms that feel like you.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Color(0xFF66716B),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
