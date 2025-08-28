import 'package:fake_store/app/shared/widgets/search_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SearchInput', () {
    testWidgets('deve exibir hintText corretamente', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SearchInput(hintText: 'Buscar produtos...')),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Buscar produtos...'), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('deve chamar onChanged ao digitar', (tester) async {
      String? value;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SearchInput(onChanged: (v) => value = v)),
        ),
      );

      await tester.enterText(find.byType(TextField), 'notebook');
      expect(value, 'notebook');
    });

    testWidgets('deve chamar onSubmitted ao pressionar enter', (tester) async {
      String? submitted;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SearchInput(onSubmitted: (v) => submitted = v)),
        ),
      );

      await tester.enterText(find.byType(TextField), 'celular');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(submitted, 'celular');
    });
  });
}
