import 'dart:async';

import 'package:fake_store/app/core/data/models/product.dart';
import 'package:fake_store/app/core/data/product_repository.dart';
import 'package:fake_store/app/core/storage/favorites_store.dart';
import 'package:fake_store/app/core/ui/ui_state.dart/ui_state.dart';
import 'package:fake_store/app/modules/product_module/notifiers/products_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mocks com mocktail
class MockProductRepository extends Mock implements ProductRepository {}

class MockFavoritesStore extends Mock implements FavoritesStore {}

void main() {
  late ProductsNotifier notifier;
  late MockProductRepository repo;
  late MockFavoritesStore store;

  final mockProducts = [
    Product(
      id: 1,
      title: 'Smartphone',
      price: 1999.99,
      description: 'Top de linha',
      category: 'eletrônicos',
      image: '',
      rating: 4.7,
      ratingCount: 120,
    ),
    Product(
      id: 2,
      title: 'Tênis de Corrida',
      price: 299.90,
      description: 'Confortável',
      category: 'moda',
      image: '',
      rating: 4.4,
      ratingCount: 88,
    ),
  ];

  setUp(() {
    // Obrigatório para tipos genéricos no mocktail
    registerFallbackValue(<int>{});

    repo = MockProductRepository();
    store = MockFavoritesStore();
    notifier = ProductsNotifier(repo, store);
  });

  tearDown(() {
    notifier.dispose();
  });

  test('deve carregar produtos com sucesso e aplicar filtro vazio', () async {
    when(() => repo.fetchAll()).thenAnswer((_) async => mockProducts);
    when(() => store.load()).thenAnswer((_) async => <int>{});

    await notifier.init();

    expect(notifier.value.status, UiStatus.success);
    expect(notifier.value.data!.length, 2);
  });

  test('deve retornar erro ao carregar produtos', () async {
    when(() => repo.fetchAll()).thenThrow(Exception('Erro de rede'));
    when(() => store.load()).thenAnswer((_) async => <int>{});

    await notifier.init();

    expect(notifier.value.status, UiStatus.error);
    expect(notifier.value.error.toString(), contains('Erro de rede'));
  });

  test('deve filtrar produtos com base na query', () async {
    when(() => repo.fetchAll()).thenAnswer((_) async => mockProducts);
    when(() => store.load()).thenAnswer((_) async => <int>{});

    await notifier.init();

    notifier.setQuery('tênis');
    await Future.delayed(const Duration(milliseconds: 300));

    expect(notifier.value.status, UiStatus.success);
    expect(notifier.value.data!.length, 1);
    expect(notifier.value.data!.first.title, 'Tênis de Corrida');
  });

  test('deve adicionar e remover produto dos favoritos', () async {
    when(() => repo.fetchAll()).thenAnswer((_) async => mockProducts);
    when(() => store.load()).thenAnswer((_) async => <int>{});
    when(() => store.save(any())).thenAnswer((_) async {});

    await notifier.init();

    await notifier.toggleFavorite(1);
    expect(notifier.favorites.contains(1), isTrue);

    await notifier.toggleFavorite(1);
    expect(notifier.favorites.contains(1), isFalse);
  });

  test(
    'favoriteProducts deve retornar apenas produtos marcados como favoritos',
    () async {
      when(() => repo.fetchAll()).thenAnswer((_) async => mockProducts);
      when(() => store.load()).thenAnswer((_) async => <int>{1});

      await notifier.init();

      final favs = notifier.favoriteProducts;
      expect(favs.length, 1);
      expect(favs.first.id, 1);
    },
  );
}
