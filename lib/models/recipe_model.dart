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

    return recipes.reduce((first, second) {
      return first.id < second.id ? first : second;
    });
  }

  Future<String?> fetchFirstRecipeTitle() async {
    final recipe = await fetchRecipeWithSmallestId();
    return recipe?.title;
  }
}
