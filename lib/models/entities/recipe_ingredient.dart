enum IngredientMeasurement {
  grams(1),
  pieces(2),
  milliliters(3);

  const IngredientMeasurement(this.id);

  final int id;

  static IngredientMeasurement fromId(int id) {
    for (final measurement in IngredientMeasurement.values) {
      if (measurement.id == id) {
        return measurement;
      }
    }
    throw FormatException('Invalid ingredient measurement: $id');
  }
}

class RecipeIngredient {
  const RecipeIngredient({
    required this.id,
    required this.name,
    required this.quantity,
    required this.measurement,
  });

  final int id;
  final String name;
  final double quantity;
  final IngredientMeasurement measurement;

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final nameValue = json['name'];
    final quantityValue = json['quantity'];
    final measurementValue = json['measurement'];
    if (idValue is! num ||
        nameValue is! String ||
        quantityValue is! num ||
        measurementValue is! num) {
      throw FormatException('Invalid recipe ingredient JSON: $json');
    }

    return RecipeIngredient(
      id: idValue.toInt(),
      name: nameValue,
      quantity: quantityValue.toDouble(),
      measurement: IngredientMeasurement.fromId(measurementValue.toInt()),
    );
  }
}
