import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store/app/shared/widgets/product_card.dart';
import 'package:fake_store/app/core/data/models/product.dart';

void main() {
  group('ProductCard', () {
    final product = Product(
      id: 1,
      title: 'Fone de Ouvido Bluetooth',
      price: 249.90,
      description: 'Alta qualidade sonora e conforto',
      category: 'eletrônicos',
      image: 'https://fake.com/image.png',
      rating: 4.6,
      ratingCount: 87,
    );

    testWidgets('deve exibir os dados principais do produto', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductCard(
            product: product,
            isFavorite: false,
            onToggleFavorite: () {},
            onOpen: () {},
          ),
        ),
      );

      expect(find.text('Fone de Ouvido Bluetooth'), findsOneWidget);
      expect(find.text('\$249.90'), findsOneWidget);
      expect(find.text('4.6'), findsOneWidget);
      expect(find.text('(87 reviews)'), findsOneWidget);
    });

    testWidgets('deve exibir ícone de favorito correto', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProductCard(
            product: product,
            isFavorite: true,
            onToggleFavorite: () {},
            onOpen: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('deve acionar onOpen ao tocar no card', (tester) async {
      bool opened = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ProductCard(
            product: product,
            isFavorite: false,
            onToggleFavorite: () {},
            onOpen: () {
              opened = true;
            },
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(opened, isTrue);
    });

    testWidgets('deve acionar onToggleFavorite ao tocar no botão de favorito', (
      tester,
    ) async {
      bool toggled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ProductCard(
            product: product,
            isFavorite: false,
            onToggleFavorite: () {
              toggled = true;
            },
            onOpen: () {},
          ),
        ),
      );

      final favButton = find.byIcon(Icons.favorite_border);
      expect(favButton, findsOneWidget);

      await tester.tap(favButton);
      expect(toggled, isTrue);
    });
  });
}
