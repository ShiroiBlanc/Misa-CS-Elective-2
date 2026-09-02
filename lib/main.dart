import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const LumenShopApp());
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.accent,
  });

  final int id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final Color accent;
}

const products = [
  Product(
    id: 1,
    name: 'Arc Desk Lamp',
    category: 'Lighting',
    price: 68,
    imageUrl:
        'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=900',
    accent: Color(0xFFF2D9A6),
  ),
  Product(
    id: 2,
    name: 'Moss Carryall',
    category: 'Everyday',
    price: 84,
    imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?w=900',
    accent: Color(0xFFC9D8C0),
  ),
  Product(
    id: 3,
    name: 'Contour Chair',
    category: 'Furniture',
    price: 245,
    imageUrl:
        'https://images.unsplash.com/photo-1503602642458-232111445657?w=900',
    accent: Color(0xFFD9C7BC),
  ),
  Product(
    id: 4,
    name: 'Cedar Field Notes',
    category: 'Stationery',
    price: 22,
    imageUrl:
        'https://images.unsplash.com/photo-1517842645767-c639042777db?w=900',
    accent: Color(0xFFE8D8C4),
  ),
  Product(
    id: 5,
    name: 'Stone Pour-Over',
    category: 'Kitchen',
    price: 46,
    imageUrl:
        'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=900',
    accent: Color(0xFFD0D8DC),
  ),
  Product(
    id: 6,
    name: 'Ocher Throw',
    category: 'Textiles',
    price: 96,
    imageUrl:
        'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=900',
    accent: Color(0xFFE7C477),
  ),
];

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) => const EmptyProductDetailPage(),
    ),
  ],
);

class LumenShopApp extends StatelessWidget {
  const LumenShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Lumen Supply Co.',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF274C45)),
        scaffoldBackgroundColor: const Color(0xFFF7F5F0),
        fontFamily: 'Georgia',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F5F0),
          surfaceTintColor: Colors.transparent,
          elevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          color: Colors.white,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
        ),
      ),
      routerConfig: appRouter,
    );
  }
}

class ShopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ShopAppBar({this.showBack = false, super.key});

  final bool showBack;

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 20,
      leading: showBack
          ? IconButton(
              tooltip: 'Back to shop',
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.arrow_back_rounded),
            )
          : null,
      title: GestureDetector(
        onTap: () => context.go('/'),
        child: const Text(
          'LUMEN',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w700,
            letterSpacing: 3,
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => context.go('/'), child: const Text('Shop')),
        const SizedBox(width: 8),
      ],
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ShopAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _HomeHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.crossAxisExtent;
                final columns = width >= 1000
                    ? 4
                    : width >= 680
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

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.push('/product/${product.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: ProductImage(product: product)),
          const SizedBox(height: 10),
          Text(
            product.name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.category,
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 12,
                  color: Color(0xFF758079),
                ),
              ),
              Text(
                '\$${product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: product.accent,
      child: SizedBox.expand(
        child: Image.network(
          product.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.image_outlined,
            size: 54,
            color: Colors.black.withValues(alpha: .35),
          ),
        ),
      ),
    );
  }
}

class EmptyProductDetailPage extends StatelessWidget {
  const EmptyProductDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ShopAppBar(showBack: true),
      body: SizedBox.shrink(),
    );
  }
}
