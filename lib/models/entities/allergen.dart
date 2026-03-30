class Allergen {
  const Allergen({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory Allergen.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final nameValue = json['name'];
    if (idValue is! num || nameValue is! String) {
      throw FormatException('Invalid allergen JSON: $json');
    }
    return Allergen(
      id: idValue.toInt(),
      name: nameValue,
    );
  }
}
