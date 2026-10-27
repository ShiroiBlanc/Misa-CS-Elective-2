import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

enum PokemonStatus { initial, loading, success, error }

class PokemonState {
  const PokemonState({
    this.status = PokemonStatus.initial,
    this.pokemon = const [],
    this.selectedPokemon,
    this.errorMessage,
  });

  final PokemonStatus status;
  final List<Pokemon> pokemon;
  final Pokemon? selectedPokemon;
  final String? errorMessage;

  PokemonState copyWith({
    PokemonStatus? status,
    List<Pokemon>? pokemon,
    Pokemon? selectedPokemon,
    String? errorMessage,
    bool clearSelectedPokemon = false,
    bool clearErrorMessage = false,
  }) {
    return PokemonState(
      status: status ?? this.status,
      pokemon: pokemon ?? this.pokemon,
      selectedPokemon: clearSelectedPokemon
          ? null
          : selectedPokemon ?? this.selectedPokemon,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

final pokemonProvider = NotifierProvider<PokemonNotifier, PokemonState>(
  PokemonNotifier.new,
);

class PokemonNotifier extends Notifier<PokemonState> {
  late final PokemonService _service = PokemonService();

  @override
  PokemonState build() {
    unawaited(Future.microtask(fetchPokemon));
    return const PokemonState();
  }

  Future<void> fetchPokemon() async {
    state = state.copyWith(
      status: PokemonStatus.loading,
      clearErrorMessage: true,
    );

    try {
      final pokemon = await _service.fetchPokemon();
      state = state.copyWith(status: PokemonStatus.success, pokemon: pokemon);
    } catch (error) {
      state = state.copyWith(
        status: PokemonStatus.error,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void selectPokemon(Pokemon pokemon) {
    state = state.copyWith(selectedPokemon: pokemon);
  }
}
