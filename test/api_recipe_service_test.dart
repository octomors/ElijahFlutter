import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:elijahflutter/services/api_recipe_service.dart';

void main() {
  test('fetchRecipes parses JSON list responses', () async {
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: [
                  {'id': 1, 'title': 'Pasta'},
                  {'id': 2, 'title': 'Soup'},
                ],
              ),
            );
          },
        ),
      );

    final service = ApiRecipeService(client: dio);

    final recipes = await service.fetchRecipes();

    expect(recipes, hasLength(2));
    expect(recipes.first.title, 'Pasta');
  });

  test('fetchRecipes parses string JSON payloads', () async {
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 200,
                data: jsonEncode([
                  {'id': 3, 'title': 'Cake'},
                ]),
              ),
            );
          },
        ),
      );

    final service = ApiRecipeService(client: dio);

    final recipes = await service.fetchRecipes();

    expect(recipes, hasLength(1));
    expect(recipes.single.title, 'Cake');
  });

  test('fetchRecipes throws on non-200 responses', () async {
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.resolve(
              Response(
                requestOptions: options,
                statusCode: 500,
                data: 'error',
              ),
            );
          },
        ),
      );

    final service = ApiRecipeService(client: dio);

    await expectLater(service.fetchRecipes(), throwsException);
  });

  test('fetchRecipes throws on DioException failures', () async {
    final dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.connectionTimeout,
                message: 'timeout',
              ),
            );
          },
        ),
      );

    final service = ApiRecipeService(client: dio);

    await expectLater(
      service.fetchRecipes(),
      throwsA(
        predicate(
          (error) =>
              error is Exception &&
              error.toString().contains('connectionTimeout'),
        ),
      ),
    );
  });
}
