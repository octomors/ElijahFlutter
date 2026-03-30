import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/entities/recipe.dart';
import '../models/interfaces/recipe_service.dart';

class ApiRecipeService implements RecipeService {
  ApiRecipeService({
    Dio? client,
    this.baseUrl = 'http://localhost:8000/api',
  }) : _client = client ?? Dio();

  final Dio _client;
  final String baseUrl;

  @override
  Future<List<Recipe>> fetchRecipes() async {
    try {
      final response = await _client.get('$baseUrl/recipes/');
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load recipes (status ${response.statusCode})',
        );
      }

      var decoded = response.data;
      if (decoded is String) {
        decoded = jsonDecode(decoded);
      }

      if (decoded is! List) {
        throw Exception(
          'Unexpected response format: expected List but got ${decoded.runtimeType}',
        );
      }

      return decoded.map((item) {
        if (item is! Map<String, dynamic>) {
          throw Exception(
            'Unexpected recipe item format: ${item.runtimeType}',
          );
        }
        return Recipe.fromJson(item);
      }).toList();
    } on DioException catch (error) {
      throw Exception('Failed to load recipes: ${error.message}');
    }
  }
}
