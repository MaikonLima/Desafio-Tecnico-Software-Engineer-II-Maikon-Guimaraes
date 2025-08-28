import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store/app/shared/widgets/empty_list_widget.dart';

void main() {
  group('EmptyListWidget', () {
    testWidgets('deve exibir imagem padrão corretamente', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: EmptyListWidget())),
      );

      final image = find.byType(Image);
      expect(image, findsOneWidget);

      final Image imageWidget = tester.widget(image);
      expect(
        (imageWidget.image as AssetImage).assetName,
        'assets/images/empty_list.png',
      );
    });

    testWidgets('deve exibir imagem customizada quando fornecida', (
      WidgetTester tester,
    ) async {
      const customAsset = 'assets/images/custom_empty.png';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: EmptyListWidget(imageAsset: customAsset)),
        ),
      );

      final image = find.byType(Image);
      expect(image, findsOneWidget);

      final Image imageWidget = tester.widget(image);
      expect((imageWidget.image as AssetImage).assetName, customAsset);
    });
  });
}
