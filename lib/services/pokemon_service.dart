import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

class PokemonService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<List<Pokemon>> fetchPokemon() async {
    final response = await http.get(Uri.parse('$_baseUrl?limit=30'));

    if (response.statusCode != 200) {
      throw Exception('The PokéAPI request failed (${response.statusCode}).');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final results = body['results'] as List<dynamic>? ?? const [];

    if (results.isEmpty) {
      throw Exception('The PokéAPI returned no Pokémon.');
    }

    return results
        .map((item) => Pokemon.fromApi(item as Map<String, dynamic>))
        .take(30)
        .toList();
  }
}
