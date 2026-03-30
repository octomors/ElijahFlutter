class Recipe {
  const Recipe({
    required this.id,
    required this.title,
  });

  final int id;
  final String title;

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final titleValue = json['title'];
    if (idValue is! num || titleValue is! String) {
      throw FormatException('Invalid recipe JSON: $json');
    }
    return Recipe(
      id: idValue.toInt(),
      title: titleValue,
    );
  }
}
