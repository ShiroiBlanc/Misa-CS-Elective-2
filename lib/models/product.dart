import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.genre,
    required this.price,
    required this.imageUrl,
    required this.accent,
  });

  final int id;
  final String name;
  final String genre;
  final double price;
  final String imageUrl;
  final Color accent;
}

const products = [
  Product(
    id: 1,
    name: 'Coiling Dragon',
    genre: 'Xianxia',
    price: 4.99,
    imageUrl: 'assets/covers/coiling_dragon.webp',
    accent: Color(0xFFD8B08C),
  ),
  Product(
    id: 2,
    name: 'Desolate Era',
    genre: 'Xianxia',
    price: 3.99,
    imageUrl: 'assets/covers/desolate_era.webp',
    accent: Color(0xFFB9C5BC),
  ),
  Product(
    id: 3,
    name: 'A Will Eternal',
    genre: 'Cultivation',
    price: 5.99,
    imageUrl: 'assets/covers/a_will_eternal.webp',
    accent: Color(0xFFC8A39A),
  ),
  Product(
    id: 4,
    name: 'Overgeared',
    genre: 'LitRPG',
    price: 4.99,
    imageUrl: 'assets/covers/overgeared.webp',
    accent: Color(0xFFD6B56F),
  ),
  Product(
    id: 5,
    name: 'Young Noble Be Monster Slaying',
    genre: 'Xianxia',
    price: 4.99,
    imageUrl: 'assets/covers/young_noble_be_monster_slaying.webp',
    accent: Color(0xFFB9A7C8),
  ),
  Product(
    id: 6,
    name: 'Genius Archer\'s Streaming',
    genre: 'Sports',
    price: 4.99,
    imageUrl: 'assets/covers/genius_archers_streaming.webp',
    accent: Color(0xFFAABFD3),
  ),
  Product(
    id: 7,
    name: 'Perfect World',
    genre: 'Fantasy',
    price: 4.99,
    imageUrl: 'assets/covers/perfect_world.webp',
    accent: Color(0xFFC9B18A),
  ),
  Product(
    id: 8,
    name: 'Yama Rising',
    genre: 'Dark Fantasy',
    price: 5.99,
    imageUrl: 'assets/covers/yama_rising.webp',
    accent: Color(0xFF9FA9B8),
  ),
  Product(
    id: 9,
    name: 'Ranker\'s Return',
    genre: 'LitRPG',
    price: 3.99,
    imageUrl: 'assets/covers/rankers_return.webp',
    accent: Color(0xFFB4C7D0),
  ),
  Product(
    id: 10,
    name: 'A Blind Swordsman\'s Sword Coffin',
    genre: 'Xianxia',
    price: 5.99,
    imageUrl: 'assets/covers/blind_swordsmans_sword_coffin.webp',
    accent: Color(0xFFB99F90),
  ),
  Product(
    id: 11,
    name: 'Descent of the Demon Master',
    genre: 'Wuxia',
    price: 4.99,
    imageUrl: 'assets/covers/descent_of_the_demon_master.webp',
    accent: Color(0xFFC1A4A4),
  ),
  Product(
    id: 12,
    name: 'The Charm of Soul Pets',
    genre: 'Action',
    price: 4.99,
    imageUrl: 'assets/covers/charm_of_soul_pets.webp',
    accent: Color(0xFFD6B56F),
  ),
];
