import '../entities/recipe.dart';

abstract class RecipeService {
  Future<List<Recipe>> fetchRecipes();
}
