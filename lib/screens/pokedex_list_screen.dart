import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_detail_screen.dart';

class PokedexListScreen extends ConsumerWidget {
  const PokedexListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(pokemonProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex List'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () => ref.read(pokemonProvider.notifier).fetchPokemon(),
            tooltip: 'Refresh Pokémon',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (snapshot.status == PokemonStatus.loading ||
              snapshot.status == PokemonStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.status == PokemonStatus.error) {
            return _ErrorState(
              message: snapshot.errorMessage ?? 'Unable to load Pokémon data.',
              onRetry: () =>
                  ref.read(pokemonProvider.notifier).fetchPokemon(),
            );
          }

          if (snapshot.pokemon.isEmpty) {
            return const Center(child: Text('No Pokémon available.'));
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(pokemonProvider.notifier).fetchPokemon(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 900
                    ? 5
                    : constraints.maxWidth > 600
                        ? 3
                        : 2;

                return GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: snapshot.pokemon.length,
                  itemBuilder: (context, index) {
                    final pokemon = snapshot.pokemon[index];
                    return GestureDetector(
                      onTap: () {
                        ref.read(pokemonProvider.notifier).selectPokemon(pokemon);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PokemonDetailScreen(),
                          ),
                        );
                      },
                      child: PokemonCard(pokemon: pokemon),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
