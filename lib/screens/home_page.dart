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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth - 40;
          final columns = width >= desktopBreakpoint
              ? 4
              : width >= tabletBreakpoint
              ? 3
              : 2;
          final cellWidth = (width - ((columns - 1) * 16)) / columns;
          final tileHeight = cellWidth / .8 + 120;
          return Column(
            children: [
              const _HomeHeader(),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 22,
                    mainAxisExtent: tileHeight,
                  ),
                  itemBuilder: (context, index) =>
                      ProductCard(product: products[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            constraints.maxWidth < 600 ? 8 : 18,
            20,
            constraints.maxWidth < 600 ? 8 : 24,
          ),
          child: Builder(
            builder: (context) {
              final textTheme = Theme.of(context).textTheme;
              final description = Text(
                'Enter a library of Chinese web novels filled with cultivation, martial arts, immortal realms, and unforgettable heroes.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              );

              if (constraints.maxWidth < 600) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stories of\nthe jianghu.',
                      style: textTheme.headlineSmall,
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Stories of\nthe jianghu.',
                      style: textTheme.displaySmall,
                    ),
                  ),
                  SizedBox(
                    width: 290,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: description,
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
