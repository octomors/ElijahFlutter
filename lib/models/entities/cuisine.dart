class Cuisine {
  const Cuisine({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final nameValue = json['name'];
    if (idValue is! num || nameValue is! String) {
      throw FormatException('Invalid cuisine JSON: $json');
    }
    return Cuisine(
      id: idValue.toInt(),
      name: nameValue,
    );
  }
}
