class Pokemon {
  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.types = const <String>[],
  });

  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;

  factory Pokemon.fromApi(Map<String, dynamic> json) {
    final url = json['url'] as String? ?? '';
    final segments = url.split('/');
    final urlSegments = segments
        .where((segment) => segment.isNotEmpty)
        .toList();
    final id =
        int.tryParse(json['id']?.toString() ?? '') ??
        (urlSegments.isEmpty ? 0 : int.tryParse(urlSegments.last) ?? 0);

    return Pokemon(
      id: id,
      name: (json['name'] as String?) ?? 'Unknown',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
      types: ((json['types'] as List<dynamic>?) ?? const [])
          .map(
            (type) =>
                ((type as Map<String, dynamic>)['type']
                        as Map<String, dynamic>)['name']
                    as String,
          )
          .toList(),
    );
  }
}
