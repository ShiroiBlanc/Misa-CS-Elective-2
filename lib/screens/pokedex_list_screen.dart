import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../providers/pokedex_provider.dart';
import '../widgets/pokemon_card.dart';

class PokedexListScreen extends ConsumerWidget {
  const PokedexListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pokedexProvider);
    final notifier = ref.read(pokedexProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        actions: [
          IconButton(
            tooltip: 'Favorites',
            icon: Badge(
              isLabelVisible: state.favorites.isNotEmpty,
              label: Text('${state.favorites.length}'),
              child: const Icon(Icons.favorite),
            ),
            onPressed: () =>
                _showFavorites(context, state.favorites, state.nicknames),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: DropdownButtonFormField<String>(
              initialValue: state.selectedType,
              decoration: const InputDecoration(
                labelText: 'Filter by type',
                prefixIcon: Icon(Icons.filter_list),
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('All types'),
                ),
                ...state.types.map(
                  (type) => DropdownMenuItem(
                    value: type,
                    child: Text(type.toUpperCase()),
                  ),
                ),
              ],
              onChanged: notifier.selectType,
            ),
          ),
          Expanded(child: _content(context, ref, state)),
        ],
      ),
    );
  }

  Widget _content(BuildContext context, WidgetRef ref, PokedexState state) {
    if (state.isLoading && state.pokemon.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage != null && state.pokemon.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFF1565C0)),
            const SizedBox(height: 12),
            Text(state.errorMessage!),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ref.read(pokedexProvider.notifier).loadPokemon(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    final pokemon = state.filteredPokemon;
    if (pokemon.isEmpty) {
      return const Center(child: Text('No Pokémon match this type.'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 900
            ? 5
            : constraints.maxWidth > 600
            ? 3
            : 2;
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemCount: pokemon.length,
          itemBuilder: (context, index) => PokemonCard(
            pokemon: pokemon[index],
            nickname: state.nicknames[pokemon[index].id],
            isFavorite: state.favoriteIds.contains(pokemon[index].id),
            onFavorite: () => ref
                .read(pokedexProvider.notifier)
                .toggleFavorite(pokemon[index].id),
            onNickname: () => _editNickname(
              context,
              ref,
              pokemon[index],
              state.nicknames[pokemon[index].id],
            ),
          ),
        );
      },
    );
  }

  Future<void> _editNickname(
    BuildContext context,
    WidgetRef ref,
    Pokemon pokemon,
    String? current,
  ) async {
    final controller = TextEditingController(text: current ?? '');
    final nickname = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nickname ${pokemon.name}'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 20,
          decoration: const InputDecoration(hintText: 'Enter a nickname'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (nickname != null) {
      ref.read(pokedexProvider.notifier).updateNickname(pokemon.id, nickname);
    }
  }

  void _showFavorites(
    BuildContext context,
    List<Pokemon> favorites,
    Map<int, String> nicknames,
  ) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: favorites.isEmpty
            ? const SizedBox(
                height: 180,
                child: Center(child: Text('No favorite Pokémon yet.')),
              )
            : ListView(
                shrinkWrap: true,
                children: [
                  const ListTile(
                    title: Text(
                      'Favorite Pokémon',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...favorites.map(
                    (pokemon) => ListTile(
                      leading: Image.network(
                        pokemon.imageUrl,
                        width: 48,
                        height: 48,
                      ),
                      title: Text(
                        nicknames[pokemon.id] ?? pokemon.name.toUpperCase(),
                      ),
                      subtitle: Text(
                        '#${pokemon.id}  ${pokemon.types.join(' / ')}',
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
