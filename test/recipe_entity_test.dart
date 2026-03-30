import 'package:elijahflutter/models/entities/recipe.dart';
import 'package:elijahflutter/models/entities/recipe_ingredient.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Recipe.fromJson parses full API payloads', () {
    final recipe = Recipe.fromJson({
      'id': 10,
      'title': 'Spaghetti Carbonara',
      'description': 'Classic Italian pasta',
      'cooking_time': 30,
      'difficulty': 2,
      'cuisine': {'id': 1, 'name': 'Italian'},
      'author': {'id': 5, 'first_name': 'Ivan', 'last_name': 'Petrov'},
      'allergens': [
        {'id': 1, 'name': 'Gluten'},
      ],
      'ingredients': [
        {
          'id': 3,
          'name': 'Pasta',
          'quantity': 200,
          'measurement': 1,
        },
      ],
    });

    expect(recipe.id, 10);
    expect(recipe.title, 'Spaghetti Carbonara');
    expect(recipe.description, 'Classic Italian pasta');
    expect(recipe.cookingTime, 30);
    expect(recipe.difficulty, 2);
    expect(recipe.cuisine?.name, 'Italian');
    expect(recipe.author?.firstName, 'Ivan');
    expect(recipe.author?.email, isNull);
    expect(recipe.allergens.single.name, 'Gluten');
    expect(recipe.ingredients.single.quantity, 200);
    expect(
      recipe.ingredients.single.measurement,
      IngredientMeasurement.grams,
    );
  });
}
