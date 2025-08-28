import 'package:fake_store/app/core/data/models/product.dart';
import 'package:fake_store/app/core/data/product_repository.dart';
import 'package:fake_store/app/core/storage/favorites_store.dart';
import 'package:fake_store/app/modules/favorites_module/pages/favorites_page.dart';
import 'package:fake_store/app/modules/product_details_module/pages/details_page.dart';
import 'package:fake_store/app/modules/product_module/notifiers/products_notifier.dart';
import 'package:fake_store/app/shared/widgets/empty_list_widget.dart';
import 'package:fake_store/app/shared/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepository {}

class MockFavoritesStore extends Mock implements FavoritesStore {}

void main() {
  late MockProductRepository repo;
  late MockFavoritesStore store;
  late ProductsNotifier notifier;

  setUp(() {
    registerFallbackValue(<int>{});
    repo = MockProductRepository();
    store = MockFavoritesStore();
    notifier = ProductsNotifier(repo, store);
  });

  group('FavoritesPage', () {
    testWidgets('deve exibir EmptyListWidget quando não houver favoritos', (
      tester,
    ) async {
      notifier.setProducts([]);

      await tester.pumpWidget(
        MaterialApp(home: FavoritesPage(notifier: notifier)),
      );

      expect(find.byType(EmptyListWidget), findsOneWidget);
      expect(find.byType(ProductCard), findsNothing);
    });

    testWidgets('deve exibir ProductCard quando houver produtos favoritos', (
      tester,
    ) async {
      final product = Product(
        id: 1,
        title: 'Headphone Gamer',
        price: 349.90,
        description: 'Som imersivo e confortável',
        category: 'eletrônicos',
        image: '',
        rating: 4.5,
        ratingCount: 80,
      );

      notifier.setProducts([product]);
      await notifier.toggleFavorite(product.id);

      await tester.pumpWidget(
        MaterialApp(home: FavoritesPage(notifier: notifier)),
      );

      expect(find.byType(ProductCard), findsOneWidget);
      expect(find.text('Headphone Gamer'), findsOneWidget);
    });

    testWidgets(
      'deve navegar para ProductDetailsPage ao tocar em um produto favorito',
      (tester) async {
        final product = Product(
          id: 1,
          title: 'Relógio Digital',
          price: 149.90,
          description: 'Design moderno e resistente à água',
          category: 'moda',
          image: '',
          rating: 4.3,
          ratingCount: 42,
        );

        notifier.setProducts([product]);
        await notifier.toggleFavorite(product.id);

        await tester.pumpWidget(
          MaterialApp(
            routes: {
              '/': (context) => FavoritesPage(notifier: notifier),
              '/details': (context) {
                final id = ModalRoute.of(context)!.settings.arguments as int;
                return ProductDetailsPage(id: id, notifier: notifier);
              },
            },
          ),
        );

        await tester.tap(find.byType(ProductCard));
        await tester.pumpAndSettle();

        expect(find.byType(ProductDetailsPage), findsOneWidget);
      },
    );

    testWidgets(
      'deve remover produto dos favoritos ao tocar no botão de favorito',
      (tester) async {
        final product = Product(
          id: 1,
          title: 'Tênis Esportivo',
          price: 199.99,
          description: 'Ideal para treinos',
          category: 'calçados',
          image: '',
          rating: 4.2,
          ratingCount: 25,
        );

        notifier.setProducts([product]);
        await notifier.toggleFavorite(product.id);

        await tester.pumpWidget(
          MaterialApp(home: FavoritesPage(notifier: notifier)),
        );

        expect(find.byType(ProductCard), findsOneWidget);

        final favIcon = find.descendant(
          of: find.byType(ProductCard),
          matching: find.byIcon(Icons.favorite),
        );

        await tester.tap(favIcon);
        await tester.pumpAndSettle();

        expect(find.byType(ProductCard), findsNothing);
        expect(find.byType(EmptyListWidget), findsOneWidget);
      },
    );
  });
}
