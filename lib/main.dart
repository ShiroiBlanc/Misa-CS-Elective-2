import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/pokemon_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PokemonProvider(),
      child: const PokedexApp(),
    ),
  );
}
