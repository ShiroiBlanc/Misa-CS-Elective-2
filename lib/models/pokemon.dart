class Pokemon {
  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final String imageUrl;

  factory Pokemon.fromApi(Map<String, dynamic> json) {
    final url = json['url'] as String? ?? '';
    final segments = url.split('/');
    final id = int.tryParse(segments.where((segment) => segment.isNotEmpty).last) ?? 0;

    return Pokemon(
      id: id,
      name: (json['name'] as String?) ?? 'Unknown',
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
    );
  }
}
