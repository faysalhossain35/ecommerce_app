import 'dart:ui' show Tristate;

import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/presentation/pages/product/view/product_details_screen.dart';
import 'package:ecommerce_app/presentation/pages/review/view/reviews_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('product image carousel responds to indicators and swipes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProductDetailsScreen()));

    final secondIndicator = find.byKey(
      const ValueKey('product-image-indicator-1'),
    );
    await tester.tap(secondIndicator);
    await tester.pumpAndSettle();

    final secondIndicatorSemantics = tester
        .getSemantics(secondIndicator)
        .getSemanticsData();
    expect(
      secondIndicatorSemantics.flagsCollection.isSelected,
      Tristate.isTrue,
    );
    expect(secondIndicatorSemantics.label, 'Show product image 2');

    await tester.drag(find.byType(PageView), const Offset(-600, 0));
    await tester.pumpAndSettle();

    final thirdIndicatorSemantics = tester
        .getSemantics(find.byKey(const ValueKey('product-image-indicator-2')))
        .getSemanticsData();
    expect(
      thirdIndicatorSemantics.flagsCollection.isSelected,
      Tristate.isTrue,
    );
    expect(thirdIndicatorSemantics.label, 'Show product image 3');
    expect(tester.takeException(), isNull);
  });

  testWidgets('product details lets users select options and add to cart', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(340, 577);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    int? addedQuantity;
    Color? addedColor;
    String? addedSize;
    var reviewsTapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: ProductDetailsScreen(
          onReviewsTap: () => reviewsTapped = true,
          onAddToCart: (quantity, color, size) {
            addedQuantity = quantity;
            addedColor = color;
            addedSize = size;
          },
        ),
      ),
    );

    expect(find.text('Product Details'), findsOneWidget);
    expect(find.text('Happy New Year Special Deal Save 30%'), findsOneWidget);
    expect(find.text('\$1,000'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.tap(find.byKey(const ValueKey('product-color-0')));
    await tester.tap(find.byKey(const ValueKey('product-size-2L')));
    await tester.tap(find.text('Reviews'));
    expect(reviewsTapped, isTrue);

    await tester.tap(find.text('Add To Cart'));

    expect(addedQuantity, 2);
    expect(addedColor, AppColors.swatchBlack);
    expect(addedSize, '2L');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Reviews link opens the reviews screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ProductDetailsScreen()));

    await tester.tap(find.text('Reviews'));
    await tester.pumpAndSettle();

    expect(find.byType(ReviewsScreen), findsOneWidget);
    expect(find.text('Reviews (1000)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
