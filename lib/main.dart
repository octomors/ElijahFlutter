import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/recipe_model.dart';
import 'services/api_recipe_service.dart';
import 'view/home_page.dart';
import 'viewmodel/recipe_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<RecipeModel>(
          create: (_) => RecipeModel(ApiRecipeService()),
        ),
        ChangeNotifierProvider<RecipeViewModel>(
          create: (context) => RecipeViewModel(context.read<RecipeModel>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elijah Recipes',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}
