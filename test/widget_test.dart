import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:elijahflutter/main.dart';
import 'package:elijahflutter/models/entities/recipe.dart';
import 'package:elijahflutter/models/interfaces/recipe_service.dart';
import 'package:elijahflutter/models/recipe_model.dart';
import 'package:elijahflutter/viewmodel/recipe_view_model.dart';

class FakeRecipeService implements RecipeService {
  @override
  Future<List<Recipe>> fetchRecipes() async {
    return const [
      Recipe(id: 2, title: 'Borscht'),
      Recipe(id: 1, title: 'Salad'),
    ];
  }
}

void main() {
  testWidgets('Shows recipe title with smallest id',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<RecipeModel>(
            create: (_) => RecipeModel(FakeRecipeService()),
          ),
          ChangeNotifierProvider<RecipeViewModel>(
            create: (context) => RecipeViewModel(context.read<RecipeModel>()),
          ),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.text('Salad'), findsNothing);

    await tester.tap(find.text('Показать рецепт с минимальным Id'));
    await tester.pumpAndSettle();

    expect(find.text('Salad'), findsOneWidget);
  });
}
