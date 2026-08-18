import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const FruitApp());
}

final Map<String, String> fruitIllustrations = {
  'apple': '🍎',
  'banana': '🍌',
  'grape': '🍇',
  'orange': '🍊',
  'strawberry': '🍓',
};

String formatFruitName(String fruitName) {
  return fruitName
      .split('-')
      .map((part) => part[0].toUpperCase() + part.substring(1))
      .join(' ');
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Fruit Routes'),
            centerTitle: true,
          ),
          body: child,
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const FruitListPage(),
        ),
        GoRoute(
          path: '/fruit/:name',
          builder: (context, state) {
            final name = (state.pathParameters['name'] ?? 'apple').toLowerCase();
            final illustration = fruitIllustrations[name] ?? '🍍';

            return FruitDetailPage(
              name: name,
              illustration: illustration,
            );
          },
        ),
      ],
    ),
  ],
);

class FruitApp extends StatelessWidget {
  const FruitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Fruit Router Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

class FruitListPage extends StatelessWidget {
  const FruitListPage({super.key});

  static const List<String> fruits = [
    'apple',
    'banana',
    'grape',
    'orange',
    'strawberry',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: fruits.length,
      separatorBuilder: (_, _) => const Divider(),
      itemBuilder: (context, index) {
        final fruit = fruits[index];

        return ListTile(
          leading: Text(
            fruitIllustrations[fruit] ?? '🍍',
            style: const TextStyle(fontSize: 28),
          ),
          title: Text(formatFruitName(fruit)),
          trailing: const Icon(Icons.arrow_forward_ios_rounded),
          onTap: () {
            context.go('/fruit/$fruit');
          },
        );
      },
    );
  }
}

class FruitDetailPage extends StatelessWidget {
  const FruitDetailPage({
    super.key,
    required this.name,
    required this.illustration,
  });

  final String name;
  final String illustration;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              illustration,
              style: const TextStyle(fontSize: 110),
            ),
            const SizedBox(height: 16),
            Text(
              formatFruitName(name),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              'Current route: /fruit/$name',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.go('/'),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to fruit list'),
            ),
          ],
        ),
      ),
    );
  }
}
