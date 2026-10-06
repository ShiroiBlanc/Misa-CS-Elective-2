import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/pokemon_provider.dart';

class PokemonDetailScreen extends StatelessWidget {
  const PokemonDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pokemon = context.watch<PokemonProvider>().selectedPokemon;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Details'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: pokemon == null
          ? const Center(child: Text('No Pokémon selected.'))
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      pokemon.imageUrl,
                      height: 240,
                      width: 240,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.catching_pokemon, size: 160);
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '#${pokemon.id}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}