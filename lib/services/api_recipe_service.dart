import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/entities/recipe.dart';
import '../models/interfaces/recipe_service.dart';

class RecipeServiceException implements Exception {
  const RecipeServiceException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => cause == null ? message : '$message: $cause';
}

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
        throw RecipeServiceException(
          'Failed to load recipes (status ${response.statusCode})',
        );
      }

      final rawData = response.data;
      final responseData = rawData is String ? jsonDecode(rawData) : rawData;

      if (responseData is! List) {
        throw RecipeServiceException(
          'Unexpected response format: expected List but got ${responseData.runtimeType}',
        );
      }

      return responseData.map((item) {
        if (item is! Map<String, dynamic>) {
          throw RecipeServiceException(
            'Unexpected recipe item format: ${item.runtimeType}',
          );
        }
        return Recipe.fromJson(item);
      }).toList();
    } on DioException catch (error) {
      throw RecipeServiceException('Failed to load recipes', error);
    }
  }
}
