import 'package:go_router/go_router.dart';

import '../screens/product_detail_page.dart';
import '../screens/home_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) =>
          ProductDetailPage(productId: state.pathParameters['id']!),
    ),
  ],
);
