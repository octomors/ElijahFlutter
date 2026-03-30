class Ingredient {
  const Ingredient({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final nameValue = json['name'];
    if (idValue is! num || nameValue is! String) {
      throw FormatException('Invalid ingredient JSON: $json');
    }
    return Ingredient(
      id: idValue.toInt(),
      name: nameValue,
    );
  }
}
