import 'package:go_router/go_router.dart';

import '../models/product.dart';
import '../screens/product_detail_page.dart';
import '../screens/home_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final productId = int.parse(state.pathParameters['id']!);
        final product = products.firstWhere((item) => item.id == productId);
        return ProductDetailPage(product: product);
      },
    ),
  ],
);
