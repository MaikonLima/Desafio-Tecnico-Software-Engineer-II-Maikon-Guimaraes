import 'package:fake_store/app/modules/error_module/pages/error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fake_store/app/core/constants/app_strings.dart';

void main() {
  group('ErrorScreen', () {
    testWidgets('deve exibir título e subtítulo padrão de erro de rede', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: ErrorScreen(kind: AppErrorKind.network)),
      );

      expect(find.text(AppStrings.noConnection), findsOneWidget);
      expect(find.text(AppStrings.checkInternt), findsOneWidget);
    });

    testWidgets('deve exibir título e subtítulo de timeout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: ErrorScreen(kind: AppErrorKind.timeout)),
      );

      expect(find.text(AppStrings.requestTimeOut), findsOneWidget);
      expect(find.text(AppStrings.problemServer), findsOneWidget);
    });

    testWidgets('deve exibir botão Tentar Novamente e acionar onRetry', (
      WidgetTester tester,
    ) async {
      bool called = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ErrorScreen(
            kind: AppErrorKind.server,
            onRetry: () {
              called = true;
            },
          ),
        ),
      );

      expect(find.text(AppStrings.tryAgain), findsOneWidget);
      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pump();

      expect(called, isTrue);
    });

    testWidgets('deve acionar onGoHome ao clicar em Voltar para Home', (
      WidgetTester tester,
    ) async {
      bool goHomeCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: ErrorScreen(
            kind: AppErrorKind.unknown,
            onGoHome: () {
              goHomeCalled = true;
            },
          ),
        ),
      );

      await tester.tap(find.text(AppStrings.goHome));
      await tester.pump();

      expect(goHomeCalled, isTrue);
    });

    testWidgets('deve exibir mensagem customizada se message for fornecida', (
      WidgetTester tester,
    ) async {
      const customMsg = 'Erro personalizado';

      await tester.pumpWidget(
        const MaterialApp(
          home: ErrorScreen(kind: AppErrorKind.unknown, message: customMsg),
        ),
      );

      expect(find.text(customMsg), findsOneWidget);
    });
  });
}
