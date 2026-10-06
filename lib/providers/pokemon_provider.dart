import 'package:flutter/foundation.dart';

import '../models/pokemon.dart';
import '../services/pokemon_service.dart';

enum PokemonStatus { initial, loading, success, error }

class PokemonProvider extends ChangeNotifier {
  PokemonProvider({PokemonService? service}) : _service = service ?? PokemonService() {
    fetchPokemon();
  }

  final PokemonService _service;

  PokemonStatus _status = PokemonStatus.initial;
  List<Pokemon> _pokemon = const [];
  Pokemon? _selectedPokemon;
  String? _errorMessage;

  PokemonStatus get status => _status;
  List<Pokemon> get pokemon => _pokemon;
  Pokemon? get selectedPokemon => _selectedPokemon;
  String? get errorMessage => _errorMessage;

  Future<void> fetchPokemon() async {
    _status = PokemonStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _pokemon = await _service.fetchPokemon();
      _status = PokemonStatus.success;
    } catch (error) {
      _status = PokemonStatus.error;
      _errorMessage = error.toString().replaceFirst('Exception: ', '');
    }

    notifyListeners();
  }

  void selectPokemon(Pokemon pokemon) {
    _selectedPokemon = pokemon;
    notifyListeners();
  }
}