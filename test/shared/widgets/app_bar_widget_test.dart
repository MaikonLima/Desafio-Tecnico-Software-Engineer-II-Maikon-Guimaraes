import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store/app/shared/widgets/app_bar_widget.dart';

void main() {
  group('AppBarWidget', () {
    testWidgets('deve renderizar título corretamente', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(appBar: AppBarWidget(title: 'Página Inicial')),
        ),
      );

      expect(find.text('Página Inicial'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('deve renderizar actions corretamente', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBarWidget(
              title: 'Com Ações',
              actions: [
                IconButton(icon: const Icon(Icons.search), onPressed: () {}),
              ],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('deve renderizar bottom widget e ajustar altura', (
      tester,
    ) async {
      const bottomWidget = PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: Text('Bottom Test'),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            appBar: AppBarWidget(title: 'Com Bottom', bottom: bottomWidget),
          ),
        ),
      );

      expect(find.text('Bottom Test'), findsOneWidget);

      final widget = tester.widget<AppBarWidget>(find.byType(AppBarWidget));
      expect(widget.preferredSize.height, 112);
    });
  });
}
