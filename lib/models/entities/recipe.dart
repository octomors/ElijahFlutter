class Recipe {
  const Recipe({
    required this.id,
    required this.title,
  });

  final int id;
  final String title;

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
    );
  }
}
