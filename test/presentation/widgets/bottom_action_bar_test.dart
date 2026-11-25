import 'package:ecommerce_app/presentation/widgets/bottom_action_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('price bar shows value and calls Add To Cart', (
    WidgetTester tester,
  ) async {
    var actionCalled = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomActionBar(
            title: 'Price',
            value: '\$1,000',
            actionLabel: 'Add To Cart',
            onAction: () => actionCalled = true,
          ),
        ),
      ),
    );

    expect(find.text('Price'), findsOneWidget);
    expect(find.text('\$1,000'), findsOneWidget);
    await tester.tap(find.text('Add To Cart'));

    expect(actionCalled, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('review bar shows title and calls icon action', (
    WidgetTester tester,
  ) async {
    var actionCalled = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: BottomActionBar(
            title: 'Reviews (1000)',
            actionIcon: Icons.add,
            actionSemanticLabel: 'Add review',
            onAction: () => actionCalled = true,
          ),
        ),
      ),
    );

    expect(find.text('Reviews (1000)'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('bottom-action-icon-button')));

    expect(actionCalled, isTrue);
    expect(tester.takeException(), isNull);
  });
}
