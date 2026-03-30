import 'entities/recipe.dart';
import 'interfaces/recipe_service.dart';

class RecipeModel {
  const RecipeModel(this._service);

  final RecipeService _service;

  Future<Recipe?> fetchRecipeWithSmallestId() async {
    final recipes = await _service.fetchRecipes();
    if (recipes.isEmpty) {
      return null;
    }

    Recipe smallest = recipes.first;
    for (final recipe in recipes.skip(1)) {
      if (recipe.id < smallest.id) {
        smallest = recipe;
      }
    }
    return smallest;
  }

  Future<String?> fetchFirstRecipeTitle() async {
    final recipe = await fetchRecipeWithSmallestId();
    return recipe?.title;
  }
}
