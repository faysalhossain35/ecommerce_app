import 'package:ecommerce_app/presentation/pages/cart/view/cart_screen.dart';
import 'package:ecommerce_app/presentation/pages/cart/widgets/cart_item_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('cart screen shows sample items and screenshot total', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(340, 577);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: CartScreen()));

    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('New Year Special Shoe'), findsNWidgets(4));
    expect(find.byType(CartItemCard), findsNWidgets(4));
    expect(find.text('\$100,000.00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('quantity changes and item removal update the total', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: CartScreen(initialTotalPrice: null)),
    );

    final firstItem = find.byKey(const ValueKey('cart-item-0'));
    await tester.tap(
      find.descendant(of: firstItem, matching: find.byIcon(Icons.add)),
    );
    await tester.pump();

    expect(find.text('\$500.00'), findsOneWidget);
    expect(find.text('02'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byKey(const ValueKey('cart-item-0')),
        matching: find.byTooltip('Remove from cart'),
      ),
    );
    await tester.pump();

    expect(find.byType(CartItemCard), findsNWidgets(3));
    expect(find.text('\$300.00'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('checkout calls the supplied callback', (
    WidgetTester tester,
  ) async {
    var checkoutCalled = false;
    await tester.pumpWidget(
      MaterialApp(home: CartScreen(onCheckout: () => checkoutCalled = true)),
    );

    await tester.tap(find.text('Checkout'));

    expect(checkoutCalled, isTrue);
  });
}
