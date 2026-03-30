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
      final response = await _client.get(
        '$baseUrl/recipes/',
        options: Options(validateStatus: (_) => true),
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to load recipes (status ${response.statusCode})',
        );
      }

      var responseData = response.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      if (responseData is! List) {
        throw Exception(
          'Unexpected response format: expected List but got ${responseData.runtimeType}',
        );
      }

      return responseData.map((item) {
        if (item is! Map<String, dynamic>) {
          throw Exception(
            'Unexpected recipe item format: ${item.runtimeType}',
          );
        }
        return Recipe.fromJson(item);
      }).toList();
    } on DioException catch (error) {
      final message = error.message;
      final details = <String>[
        'type ${error.type.name}',
        if (error.response?.statusCode != null)
          'status ${error.response?.statusCode}',
        if (message != null && message.isNotEmpty) message,
      ].join(', ');
      throw Exception('Failed to load recipes ($details)');
    }
  }
}
