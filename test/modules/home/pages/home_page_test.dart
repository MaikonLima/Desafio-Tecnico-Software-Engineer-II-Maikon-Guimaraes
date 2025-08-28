import 'package:fake_store/app/core/data/models/product.dart';
import 'package:fake_store/app/core/data/product_repository.dart';
import 'package:fake_store/app/core/storage/favorites_store.dart';
import 'package:fake_store/app/modules/error_module/pages/error_page.dart';
import 'package:fake_store/app/modules/favorites_module/pages/favorites_page.dart';
import 'package:fake_store/app/modules/product_details_module/pages/details_page.dart';
import 'package:fake_store/app/modules/product_module/notifiers/products_notifier.dart';
import 'package:fake_store/app/modules/product_module/pages/products_page.dart';
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

    when(() => store.load()).thenAnswer((_) async => <int>{});

    notifier = ProductsNotifier(repo, store);
  });

  group('HomePage', () {
    testWidgets('deve exibir indicador de carregamento inicialmente', (
      tester,
    ) async {
      notifier.setLoading();

      await tester.pumpWidget(MaterialApp(home: HomePage(notifier: notifier)));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('deve redirecionar para ErrorScreen quando houver erro', (
      tester,
    ) async {
      notifier.setError(Exception('Erro simulado'));

      await tester.pumpWidget(MaterialApp(home: HomePage(notifier: notifier)));

      await tester.pumpAndSettle();

      expect(find.byType(ErrorScreen), findsOneWidget);
    });

    testWidgets('deve exibir EmptyListWidget quando lista estiver vazia', (
      tester,
    ) async {
      notifier.setProducts([]);

      await tester.pumpWidget(MaterialApp(home: HomePage(notifier: notifier)));

      expect(find.byType(EmptyListWidget), findsOneWidget);
    });

    testWidgets('deve exibir ProductCard com dados do produto da API', (
      tester,
    ) async {
      final product = Product(
        id: 0,
        title: 'string',
        price: 0.1,
        description: 'string',
        category: 'string',
        image: 'https://via.placeholder.com/150',
        rating: 0.0,
        ratingCount: 0,
      );

      notifier.setProducts([product]);

      await tester.pumpWidget(MaterialApp(home: HomePage(notifier: notifier)));

      await tester.pumpAndSettle();

      expect(find.byType(ProductCard), findsOneWidget);
      expect(find.text('string'), findsWidgets);
    });

    testWidgets(
      'deve navegar para FavoritesPage ao clicar no ícone de favorito da AppBar',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(home: HomePage(notifier: notifier)),
        );

        await tester.tap(find.byIcon(Icons.favorite_border));
        await tester.pumpAndSettle();

        expect(find.byType(FavoritesPage), findsOneWidget);
      },
    );

    testWidgets(
      'deve navegar para ProductDetailsPage ao clicar em um ProductCard',
      (tester) async {
        final product = Product(
          id: 1,
          title: 'Smart TV 4K',
          price: 2999.99,
          description: 'Qualidade de imagem incrível',
          category: 'eletrônicos',
          image: '',
          rating: 4.8,
          ratingCount: 300,
        );

        notifier.setProducts([product]);

        await tester.pumpWidget(
          MaterialApp(home: HomePage(notifier: notifier)),
        );

        await tester.tap(find.byType(ProductCard));
        await tester.pumpAndSettle();

        expect(find.byType(ProductDetailsPage), findsOneWidget);
      },
    );
  });
}
