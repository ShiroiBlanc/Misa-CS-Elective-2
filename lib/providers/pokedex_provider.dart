import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

final pokedexProvider = StateNotifierProvider<PokedexNotifier, PokedexState>(
  (ref) => PokedexNotifier(PokemonService())..loadPokemon(),
);

class PokedexState {
  const PokedexState({
    this.pokemon = const <Pokemon>[],
    this.nicknames = const <int, String>{},
    this.favoriteIds = const <int>{},
    this.selectedType,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Pokemon> pokemon;
  final Map<int, String> nicknames;
  final Set<int> favoriteIds;
  final String? selectedType;
  final bool isLoading;
  final String? errorMessage;

  List<Pokemon> get filteredPokemon => selectedType == null
      ? pokemon
      : pokemon.where((item) => item.types.contains(selectedType)).toList();

  List<String> get types =>
      pokemon.expand((item) => item.types).toSet().toList()..sort();

  List<Pokemon> get favorites =>
      pokemon.where((item) => favoriteIds.contains(item.id)).toList();

  PokedexState copyWith({
    List<Pokemon>? pokemon,
    Map<int, String>? nicknames,
    Set<int>? favoriteIds,
    String? selectedType,
    bool clearSelectedType = false,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PokedexState(
      pokemon: pokemon ?? this.pokemon,
      nicknames: nicknames ?? this.nicknames,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      selectedType: clearSelectedType
          ? null
          : selectedType ?? this.selectedType,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class PokedexNotifier extends StateNotifier<PokedexState> {
  PokedexNotifier(this._service) : super(const PokedexState());

  final PokemonService _service;

  Future<void> loadPokemon() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final pokemon = await _service.fetchPokemon();
      state = state.copyWith(pokemon: pokemon, isLoading: false);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Unable to load Pokémon data.',
      );
    }
  }

  void toggleFavorite(int id) {
    final favorites = {...state.favoriteIds};
    if (!favorites.add(id)) favorites.remove(id);
    state = state.copyWith(favoriteIds: favorites);
  }

  void updateNickname(int id, String nickname) {
    final nicknames = {...state.nicknames};
    if (nickname.trim().isEmpty) {
      nicknames.remove(id);
    } else {
      nicknames[id] = nickname.trim();
    }
    state = state.copyWith(nicknames: nicknames);
  }

  void selectType(String? type) {
    state = type == null
        ? state.copyWith(clearSelectedType: true)
        : state.copyWith(selectedType: type);
  }
}
