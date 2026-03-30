import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/entities/recipe.dart';
import '../models/interfaces/recipe_service.dart';

class ApiRecipeService implements RecipeService {
  ApiRecipeService({
    http.Client? client,
    this.baseUrl = 'http://localhost:8000/api',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  @override
  Future<List<Recipe>> fetchRecipes() async {
    final uri = Uri.parse('$baseUrl/recipes/');
    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Failed to load recipes (status ${response.statusCode})');
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw Exception('Unexpected response format');
    }

    return decoded
        .cast<Map<String, dynamic>>()
        .map(Recipe.fromJson)
        .toList();
  }
}
