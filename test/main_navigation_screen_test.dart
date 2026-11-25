import 'dart:ui' show Tristate;

import 'package:ecommerce_app/presentation/pages/cart/view/cart_screen.dart';
import 'package:ecommerce_app/presentation/pages/home/view/main_navigation_screen.dart';
import 'package:ecommerce_app/presentation/pages/splash/view/splash_screen.dart';
import 'package:ecommerce_app/presentation/pages/wishlist/view/wishlist_screen.dart';
import 'package:ecommerce_app/presentation/widgets/categories_grid_widget.dart';
import 'package:ecommerce_app/presentation/widgets/product_card.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('splash opens the main navigation screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.byType(MainNavigationScreen), findsOneWidget);
    expect(
      find.byKey(const ValueKey('bottom-navigation-home')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('bottom navigation switches between all main destinations', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: MainNavigationScreen()));

    final homeTab = find.byKey(const ValueKey('bottom-navigation-home'));
    expect(homeTab, findsOneWidget);
    expect(
      tester
          .getSemantics(homeTab)
          .getSemanticsData()
          .flagsCollection
          .isSelected,
      Tristate.isTrue,
    );

    await tester.tap(
      find.byKey(const ValueKey('bottom-navigation-categories')),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CategoriesGridWidget), findsOneWidget);

    expect(find.byKey(const ValueKey('cart-count-badge')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('bottom-navigation-cart')));
    await tester.pumpAndSettle();
    expect(find.byType(CartScreen), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottom-navigation-wish')));
    await tester.pumpAndSettle();
    expect(find.byType(WishlistScreen), findsOneWidget);
    expect(find.text('Your wish list is empty'), findsOneWidget);

    await tester.tap(homeTab);
    await tester.pumpAndSettle();
    expect(find.text('Brands'), findsOneWidget);
    expect(
      tester
          .getSemantics(homeTab)
          .getSemanticsData()
          .flagsCollection
          .isSelected,
      Tristate.isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('product actions update the cart and wish list tabs', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: MainNavigationScreen()));

    final firstHomeProduct = find.byType(ProductCard).first;
    await tester.ensureVisible(firstHomeProduct);
    await tester.tap(firstHomeProduct);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byKey(const ValueKey('product-color-0')));
    await tester.tap(find.byKey(const ValueKey('product-size-2L')));
    await tester.tap(find.byKey(const ValueKey('product-details-wishlist')));
    await tester.tap(find.text('Add To Cart'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('bottom-navigation-cart')));
    await tester.pumpAndSettle();
    final cartBadge = find.byKey(const ValueKey('cart-count-badge'));
    expect(cartBadge, findsOneWidget);
    expect(
      find.descendant(of: cartBadge, matching: find.text('2')),
      findsOneWidget,
    );
    expect(find.text('New Year Special Shoe 30'), findsOneWidget);
    expect(find.text('Color: Black, Size: 2L'), findsOneWidget);
    expect(find.text('\$200.00'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: cartBadge, matching: find.text('3')),
      findsOneWidget,
    );
    expect(find.text('\$300.00'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottom-navigation-wish')));
    await tester.pumpAndSettle();
    expect(find.text('New Year Special Shoe 30'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('product-wishlist-button')));
    await tester.pumpAndSettle();
    expect(find.text('Your wish list is empty'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('bottom-navigation-home')));
    await tester.pumpAndSettle();
    final firstWishlistProduct = find.byType(ProductCard).first;
    await tester.ensureVisible(firstWishlistProduct);
    final productWishlistButton = find
        .byKey(const ValueKey('product-wishlist-button'))
        .first;
    await tester.tap(productWishlistButton);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('bottom-navigation-wish')));
    await tester.pumpAndSettle();
    expect(find.text('New Year Special Shoe 30'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
