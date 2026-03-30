import 'allergen.dart';
import 'cuisine.dart';
import 'recipe_ingredient.dart';
import 'user.dart';

class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    this.description,
    this.cookingTime,
    this.difficulty,
    this.cuisine,
    this.author,
    this.allergens = const [],
    this.ingredients = const [],
  });

  final int id;
  final String title;
  final String? description;
  final int? cookingTime;
  final int? difficulty;
  final Cuisine? cuisine;
  final User? author;
  final List<Allergen> allergens;
  final List<RecipeIngredient> ingredients;

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final titleValue = json['title'];
    if (idValue is! num || titleValue is! String) {
      throw FormatException('Invalid recipe JSON: $json');
    }

    final descriptionValue = json['description'];
    if (descriptionValue != null && descriptionValue is! String) {
      throw FormatException('Invalid recipe JSON: $json');
    }

    final cookingTimeValue = json['cooking_time'];
    if (cookingTimeValue != null && cookingTimeValue is! num) {
      throw FormatException('Invalid recipe JSON: $json');
    }

    final difficultyValue = json['difficulty'];
    if (difficultyValue != null && difficultyValue is! num) {
      throw FormatException('Invalid recipe JSON: $json');
    }

    final cuisineValue = json['cuisine'];
    Cuisine? cuisine;
    if (cuisineValue != null) {
      if (cuisineValue is! Map<String, dynamic>) {
        throw FormatException('Invalid recipe JSON: $json');
      }
      cuisine = Cuisine.fromJson(cuisineValue);
    }

    final authorValue = json['author'];
    User? author;
    if (authorValue != null) {
      if (authorValue is! Map<String, dynamic>) {
        throw FormatException('Invalid recipe JSON: $json');
      }
      author = User.fromJson(authorValue);
    }

    final allergensValue = json['allergens'];
    List<Allergen> allergens = [];
    if (allergensValue != null) {
      if (allergensValue is! List) {
        throw FormatException('Invalid recipe JSON: $json');
      }
      allergens = allergensValue.map((item) {
        if (item is! Map<String, dynamic>) {
          throw FormatException('Invalid recipe JSON: $json');
        }
        return Allergen.fromJson(item);
      }).toList();
    }

    final ingredientsValue = json['ingredients'];
    List<RecipeIngredient> ingredients = [];
    if (ingredientsValue != null) {
      if (ingredientsValue is! List) {
        throw FormatException('Invalid recipe JSON: $json');
      }
      ingredients = ingredientsValue.map((item) {
        if (item is! Map<String, dynamic>) {
          throw FormatException('Invalid recipe JSON: $json');
        }
        return RecipeIngredient.fromJson(item);
      }).toList();
    }

    return Recipe(
      id: idValue.toInt(),
      title: titleValue,
      description: descriptionValue as String?,
      cookingTime: cookingTimeValue == null ? null : cookingTimeValue.toInt(),
      difficulty: difficultyValue == null ? null : difficultyValue.toInt(),
      cuisine: cuisine,
      author: author,
      allergens: allergens,
      ingredients: ingredients,
    );
  }
}
