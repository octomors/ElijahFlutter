import 'package:flutter/foundation.dart';

import '../models/recipe_model.dart';

class RecipeViewModel extends ChangeNotifier {
  RecipeViewModel(this._model);

  final RecipeModel _model;

  String? recipeTitle;
  String? errorMessage;
  bool isLoading = false;

  Future<void> loadFirstRecipeTitle() async {
    isLoading = true;
    errorMessage = null;
    recipeTitle = null;
    notifyListeners();

    try {
      final title = await _model.fetchFirstRecipeTitle();
      recipeTitle = title;
      if (title == null) {
        errorMessage = 'Рецепты не найдены';
      }
    } catch (_) {
      errorMessage = 'Не удалось загрузить рецепт';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
