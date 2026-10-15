import 'package:flutter/material.dart';

import '../models/pokemon.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.nickname,
    required this.isFavorite,
    required this.onFavorite,
    required this.onNickname,
  });

  final Pokemon pokemon;
  final String? nickname;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onNickname;

  static const typeColors = <String, Color>{
    'normal': Colors.grey,
    'fire': Colors.red,
    'water': Colors.blue,
    'electric': Colors.amber,
    'grass': Colors.green,
    'ice': Colors.cyan,
    'fighting': Colors.deepOrange,
    'poison': Colors.purple,
    'ground': Colors.brown,
    'flying': Colors.indigo,
    'psychic': Colors.pink,
    'bug': Colors.lightGreen,
    'rock': Colors.blueGrey,
    'ghost': Colors.deepPurple,
    'dragon': Colors.teal,
    'dark': Colors.black87,
    'steel': Colors.blueGrey,
    'fairy': Colors.pinkAccent,
    'unknown': Colors.grey,
  };

  Color _typeColor(String type) => typeColors[type] ?? Colors.grey;

  Color _typeTextColor(String type) {
    final color = _typeColor(type);
    return type == 'electric' || type == 'ice' || type == 'bug'
        ? Colors.black87
        : color.computeLuminance() > 0.55
        ? Colors.black87
        : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${pokemon.id}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
                IconButton(
                  tooltip: isFavorite ? 'Remove favorite' : 'Add favorite',
                  onPressed: onFavorite,
                  iconSize: 30,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? const Color(0xFF1565C0) : Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Image.network(
              pokemon.imageUrl,
              height: 120,
              width: 120,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.catching_pokemon, size: 52);
              },
            ),
            const SizedBox(height: 8),
            Text(
              nickname ??
                  pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Wrap(
              spacing: 4,
              children: pokemon.types
                  .map(
                    (type) => Chip(
                      label: Text(type),
                      backgroundColor: _typeColor(type),
                      labelStyle: TextStyle(
                        color: _typeTextColor(type),
                        fontWeight: FontWeight.w600,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
            TextButton.icon(
              onPressed: onNickname,
              icon: const Icon(Icons.edit, size: 20),
              label: const Text('Nickname'),
            ),
          ],
        ),
      ),
    );
  }
}
