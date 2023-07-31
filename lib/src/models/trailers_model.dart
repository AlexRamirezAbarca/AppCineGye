class MovieTrailer {
  final String id;
  final String name;
  final String type;
  final String key;

  MovieTrailer({required this.id, required this.name, required this.type, required this.key});

  factory MovieTrailer.fromJson(Map<String, dynamic> json) {
    return MovieTrailer(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      key: json['key'],
    );
  }
}