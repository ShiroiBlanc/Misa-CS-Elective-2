import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.condition,
    required this.price,
    required this.stock,
    required this.imageUrl,
    required this.localImageUrl,
    required this.accent,
  });

  factory Product.fromMap(Map<String, dynamic> row) {
    final firstImage = row['image_url'] as String?;
    final title = row['name'] as String? ?? 'Untitled book';
    final category = row['categories'] is Map
        ? row['categories']['name'] as String?
        : null;

    return Product(
      id: row['id'].toString(),
      name: title,
      description: row['description'] as String? ?? '',
      category: category ?? 'textbooks',
      condition: 'good',
      price: (row['price'] as num?)?.toDouble() ?? 0,
      stock: (row['stock'] as num?)?.toInt() ?? 0,
      imageUrl: firstImage,
      localImageUrl: _localImageFor(title),
      accent: _accentFor(category),
    );
  }

  final String id;
  final String name;
  final String description;
  final String category;
  final String condition;
  final double price;
  final int stock;
  final String? imageUrl;
  final String? localImageUrl;
  final Color accent;

  static Color _accentFor(String? category) {
    switch (category) {
      case 'textbooks':
        return const Color(0xFFD8B08C);
      case 'supplies':
        return const Color(0xFFAABFD3);
      default:
        return const Color(0xFFC8A39A);
    }
  }

  static String? _localImageFor(String title) {
    final images = <String, String>{
      'Coiling Dragon': 'assets/covers/coiling_dragon.webp',
      'Desolate Era': 'assets/covers/desolate_era.webp',
      'A Will Eternal': 'assets/covers/a_will_eternal.webp',
      'Overgeared': 'assets/covers/overgeared.webp',
      'Perfect World': 'assets/covers/perfect_world.webp',
      'Yama Rising': 'assets/covers/yama_rising.webp',
      'Descent of the Demon Master':
          'assets/covers/descent_of_the_demon_master.webp',
      'The Charm of Soul Pets': 'assets/covers/charm_of_soul_pets.webp',
      'Ranker\'s Return': 'assets/covers/rankers_return.webp',
      'A Blind Swordsman\'s Sword Coffin':
          'assets/covers/blind_swordsmans_sword_coffin.webp',
      'Young Noble Be Monster Slaying':
          'assets/covers/young_noble_be_monster_slaying.webp',
      'Genius Archer\'s Streaming':
          'assets/covers/genius_archers_streaming.webp',
    };
    return images[title];
  }

  String get conditionLabel => condition
      .replaceAll('_', ' ')
      .split(' ')
      .map((word) {
        return word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}';
      })
      .join(' ');
}

const localBooks = [
  Product(
    id: 'local-coiling-dragon',
    name: 'Coiling Dragon',
    description: 'A physical xianxia novel for collectors and new readers.',
    category: 'xianxia',
    condition: 'new',
    price: 350,
    stock: 10,
    imageUrl: 'assets/covers/coiling_dragon.webp',
    localImageUrl: 'assets/covers/coiling_dragon.webp',
    accent: Color(0xFFD8B08C),
  ),
  Product(
    id: 'local-desolate-era',
    name: 'Desolate Era',
    description: 'A sweeping cultivation epic in physical book form.',
    category: 'xianxia',
    condition: 'new',
    price: 420,
    stock: 8,
    imageUrl: 'assets/covers/desolate_era.webp',
    localImageUrl: 'assets/covers/desolate_era.webp',
    accent: Color(0xFFB9C5BC),
  ),
  Product(
    id: 'local-will-eternal',
    name: 'A Will Eternal',
    description: 'A funny and heartfelt cultivation adventure.',
    category: 'xianxia',
    condition: 'like_new',
    price: 380,
    stock: 12,
    imageUrl: 'assets/covers/a_will_eternal.webp',
    localImageUrl: 'assets/covers/a_will_eternal.webp',
    accent: Color(0xFFC8A39A),
  ),
  Product(
    id: 'local-overgeared',
    name: 'Overgeared',
    description: 'A physical copy of this popular progression fantasy.',
    category: 'xuanhuan',
    condition: 'new',
    price: 460,
    stock: 7,
    imageUrl: 'assets/covers/overgeared.webp',
    localImageUrl: 'assets/covers/overgeared.webp',
    accent: Color(0xFFD6B56F),
  ),
  Product(
    id: 'local-perfect-world',
    name: 'Perfect World',
    description: 'A classic Chinese fantasy journey.',
    category: 'xianxia',
    condition: 'good',
    price: 325,
    stock: 9,
    imageUrl: 'assets/covers/perfect_world.webp',
    localImageUrl: 'assets/covers/perfect_world.webp',
    accent: Color(0xFFC9B18A),
  ),
  Product(
    id: 'local-yama-rising',
    name: 'Yama Rising',
    description: 'Dark fantasy and martial arts for your bookshelf.',
    category: 'wuxia',
    condition: 'new',
    price: 395,
    stock: 6,
    imageUrl: 'assets/covers/yama_rising.webp',
    localImageUrl: 'assets/covers/yama_rising.webp',
    accent: Color(0xFF9FA9B8),
  ),
  Product(
    id: 'local-demon-master',
    name: 'Descent of the Demon Master',
    description: 'A modern life meets ancient martial arts story.',
    category: 'wuxia',
    condition: 'like_new',
    price: 410,
    stock: 8,
    imageUrl: 'assets/covers/descent_of_the_demon_master.webp',
    localImageUrl: 'assets/covers/descent_of_the_demon_master.webp',
    accent: Color(0xFFC1A4A4),
  ),
  Product(
    id: 'local-soul-pets',
    name: 'The Charm of Soul Pets',
    description: 'An action-packed Chinese fantasy novel.',
    category: 'xuanhuan',
    condition: 'good',
    price: 300,
    stock: 10,
    imageUrl: 'assets/covers/charm_of_soul_pets.webp',
    localImageUrl: 'assets/covers/charm_of_soul_pets.webp',
    accent: Color(0xFFD6B56F),
  ),
];
