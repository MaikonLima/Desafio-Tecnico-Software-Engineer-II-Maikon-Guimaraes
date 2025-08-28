import 'package:fake_store/app/shared/widgets/empty_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EmptyListScreen', () {
    testWidgets('deve exibir título correto para AppErrorKind.network', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: EmptyListScreen(kind: AppErrorKind.network)),
      );

      expect(find.text('No connection'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('deve exibir título correto para AppErrorKind.timeout', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: EmptyListScreen(kind: AppErrorKind.timeout)),
      );

      expect(find.text('Request timed out'), findsOneWidget);
    });

    testWidgets('deve exibir título correto para AppErrorKind.server', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: EmptyListScreen(kind: AppErrorKind.server)),
      );

      expect(find.text('Server error'), findsOneWidget);
    });

    testWidgets('deve exibir botão "Go Home" e acionar Navigator.popUntil', (
      tester,
    ) async {
      final navigatorObserver = _MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          home: const EmptyListScreen(kind: AppErrorKind.unknown),
          navigatorObservers: [navigatorObserver],
        ),
      );

      final goHomeButton = find.text('Go Home');
      expect(goHomeButton, findsOneWidget);

      await tester.tap(goHomeButton);
      await tester.pumpAndSettle();

      expect(navigatorObserver.popUntilCalled, isTrue);
    });
  });
}

class _MockNavigatorObserver extends NavigatorObserver {
  bool popUntilCalled = false;

  @override
  void popUntil(RoutePredicate predicate) {
    popUntilCalled = true;
  }
}
