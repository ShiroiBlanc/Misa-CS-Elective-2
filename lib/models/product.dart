import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.accent,
  });

  final int id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final Color accent;
}

const products = [
  Product(
    id: 1,
    name: 'Arc Desk Lamp',
    category: 'Lighting',
    price: 68,
    imageUrl:
        'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=900',
    accent: Color(0xFFF2D9A6),
  ),
  Product(
    id: 2,
    name: 'Moss Carryall',
    category: 'Everyday',
    price: 84,
    imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?w=900',
    accent: Color(0xFFC9D8C0),
  ),
  Product(
    id: 3,
    name: 'Contour Chair',
    category: 'Furniture',
    price: 245,
    imageUrl:
        'https://images.unsplash.com/photo-1503602642458-232111445657?w=900',
    accent: Color(0xFFD9C7BC),
  ),
  Product(
    id: 4,
    name: 'Cedar Field Notes',
    category: 'Stationery',
    price: 22,
    imageUrl:
        'https://images.unsplash.com/photo-1517842645767-c639042777db?w=900',
    accent: Color(0xFFE8D8C4),
  ),
  Product(
    id: 5,
    name: 'Stone Pour-Over',
    category: 'Kitchen',
    price: 46,
    imageUrl:
        'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?w=900',
    accent: Color(0xFFD0D8DC),
  ),
  Product(
    id: 6,
    name: 'Ocher Throw',
    category: 'Textiles',
    price: 96,
    imageUrl:
        'https://images.unsplash.com/photo-1584100936595-c0654b55a2e2?w=900',
    accent: Color(0xFFE7C477),
  ),
];
