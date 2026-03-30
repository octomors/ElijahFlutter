import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/recipe_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeViewModel>(
      builder: (context, viewModel, _) {
        final title = viewModel.recipeTitle;
        final error = viewModel.errorMessage;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Recipes'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : viewModel.loadFirstRecipeTitle,
                  child: const Text('Показать рецепт с минимальным Id'),
                ),
                const SizedBox(height: 16),
                if (viewModel.isLoading)
                  const CircularProgressIndicator()
                else if (title != null)
                  Text(
                    title,
                    key: const Key('recipeTitle'),
                    style: Theme.of(context).textTheme.titleLarge,
                  )
                else if (error != null)
                  Text(
                    error,
                    key: const Key('recipeError'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
