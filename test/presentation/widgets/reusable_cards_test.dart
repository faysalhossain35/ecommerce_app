import 'package:ecommerce_app/presentation/widgets/category_card.dart';
import 'package:ecommerce_app/presentation/widgets/product_card.dart';
import 'package:ecommerce_app/presentation/widgets/products_widget.dart';
import 'package:ecommerce_app/presentation/widgets/product_grid_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('category card shows its title and handles taps', (
    WidgetTester tester,
  ) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CategoryCard(
            title: 'Electronics',
            icon: Icons.desktop_windows_outlined,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Electronics'), findsOneWidget);
    await tester.tap(find.byType(CategoryCard));
    expect(tapped, isTrue);
  });

  testWidgets('product card shows product details', (
    WidgetTester tester,
  ) async {
    var wishlistTapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 180,
            child: ProductCard(
              title: 'New Year Special Shoe',
              price: '\$100',
              rating: 4.8,
              onWishlistTap: () => wishlistTapped = true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('New Year Special Shoe'), findsOneWidget);
    expect(find.text('\$100'), findsOneWidget);
    expect(find.text('4.8'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('product-wishlist-button')));
    expect(wishlistTapped, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('product grid widget builds a grid from its items', (
    WidgetTester tester,
  ) async {
    var backTapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: ProductGridWidget(
          items: const [
            ProductItem(title: 'Shoe 1', price: '\$100', rating: 4.8),
            ProductItem(title: 'Shoe 2', price: '\$120', rating: 4.6),
            ProductItem(title: 'Shoe 3', price: '\$90', rating: 4.9),
          ],
          onBack: () => backTapped = true,
        ),
      ),
    );

    expect(find.text('Wish List'), findsOneWidget);
    expect(find.byType(ProductCard), findsNWidgets(3));
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    expect(backTapped, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('products widget shows cards and handles See All', (
    WidgetTester tester,
  ) async {
    var seeAllTapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProductsWidget(
            items: const [
              ProductItem(title: 'Shoe 1', price: '\$100', rating: 4.8),
              ProductItem(title: 'Shoe 2', price: '\$120', rating: 4.6),
              ProductItem(title: 'Shoe 3', price: '\$90', rating: 4.9),
            ],
            onSeeAll: () => seeAllTapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Popular'), findsOneWidget);
    expect(find.byType(ProductCard), findsNWidgets(3));
    await tester.tap(find.text('See All'));
    expect(seeAllTapped, isTrue);
    expect(tester.takeException(), isNull);
  });
}
