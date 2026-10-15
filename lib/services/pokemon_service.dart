import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon.dart';

class PokemonService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<List<Pokemon>> fetchPokemon() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl?limit=30'));

      if (response.statusCode != 200) {
        return _fallbackPokemon();
      }

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final results = body['results'] as List<dynamic>? ?? const [];

      if (results.isEmpty) {
        return _fallbackPokemon();
      }

      return await Future.wait(
        results.take(30).map((item) async {
          final summary = item as Map<String, dynamic>;
          final detailsResponse = await http.get(
            Uri.parse(summary['url'] as String),
          );
          if (detailsResponse.statusCode == 200) {
            return Pokemon.fromApi(
              jsonDecode(detailsResponse.body) as Map<String, dynamic>,
            );
          }
          return Pokemon.fromApi(summary);
        }),
      );
    } catch (_) {
      return _fallbackPokemon();
    }
  }

  List<Pokemon> _fallbackPokemon() {
    return List.generate(
      30,
      (index) => Pokemon(
        id: index + 1,
        name: 'pokemon-${index + 1}',
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${index + 1}.png',
        types: const ['unknown'],
      ),
    );
  }
}
