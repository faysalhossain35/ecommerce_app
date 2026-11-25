import 'dart:ui' show Tristate;

import 'package:ecommerce_app/data/models/brand_model.dart';
import 'package:ecommerce_app/data/models/category_model.dart';
import 'package:ecommerce_app/data/models/product_model.dart';
import 'package:ecommerce_app/data/service/brand_service.dart';
import 'package:ecommerce_app/data/service/category_service.dart';
import 'package:ecommerce_app/data/service/product_service.dart';
import 'package:ecommerce_app/presentation/pages/brand/providers/brand_provider.dart';
import 'package:ecommerce_app/presentation/pages/category/providers/category_provider.dart';
import 'package:ecommerce_app/presentation/pages/product/providers/product_provider.dart';
import 'package:ecommerce_app/presentation/pages/product/view/category_products_screen.dart';
import 'package:ecommerce_app/presentation/pages/home/view/home_screen.dart';
import 'package:ecommerce_app/presentation/pages/product/view/product_details_screen.dart';
import 'package:ecommerce_app/presentation/widgets/categories_grid_widget.dart';
import 'package:ecommerce_app/presentation/widgets/category_card.dart';
import 'package:ecommerce_app/presentation/widgets/product_card.dart';
import 'package:ecommerce_app/presentation/widgets/product_grid_widget.dart';
import 'package:ecommerce_app/presentation/widgets/products_widget.dart';
import 'package:ecommerce_app/presentation/widgets/section_header.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('home and category grid display CategoryProvider data', (
    WidgetTester tester,
  ) async {
    final provider = CategoryProvider(service: _CategoryService());
    addTearDown(provider.dispose);

    await provider.fetchCategories();
    await tester.pumpWidget(
      ChangeNotifierProvider<CategoryProvider>.value(
        value: provider,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expect(find.text('Books'), findsOneWidget);
    expect(find.text('Electronics'), findsNothing);
    await tester.tap(find.text('See All').first);
    await tester.pumpAndSettle();

    expect(find.byType(CategoriesGridWidget), findsOneWidget);
    expect(find.byType(CategoryCard), findsNWidgets(2));
    expect(find.text('Books'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
  });

  testWidgets('selecting an API category fetches its API products', (
    WidgetTester tester,
  ) async {
    final categoryProvider = CategoryProvider(service: _CategoryService());
    final productService = _ProductService();
    final productProvider = ProductProvider(service: productService);
    addTearDown(categoryProvider.dispose);
    addTearDown(productProvider.dispose);
    await categoryProvider.fetchCategories();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CategoryProvider>.value(
            value: categoryProvider,
          ),
          ChangeNotifierProvider<ProductProvider>.value(value: productProvider),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    await tester.tap(find.text('Books'));
    await tester.pumpAndSettle();

    expect(find.byType(CategoryProductsScreen), findsOneWidget);
    expect(find.text('Category Book'), findsOneWidget);
    expect(productService.requestedCategoryId, 'category-books');
  });

  testWidgets('home screen displays brands from BrandProvider', (
    WidgetTester tester,
  ) async {
    final provider = BrandProvider(service: _BrandService());
    addTearDown(provider.dispose);

    await provider.fetchBrands();
    await tester.pumpWidget(
      ChangeNotifierProvider<BrandProvider>.value(
        value: provider,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expect(find.text('Brands'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Samsung'), findsOneWidget);
    expect(find.text('Popular'), findsNothing);
  });

  testWidgets('home screen fits the reference mobile width', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(260, 708);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pump();

    expect(find.text('All Categories'), findsOneWidget);
    expect(find.text('Brands'), findsOneWidget);
    expect(find.text('Special'), findsOneWidget);
    expect(find.text('New'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('each See All button opens its matching product grid', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(260, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pump();

    for (final section in ['Special', 'New']) {
      final productsWidget = find.byWidgetPredicate(
        (widget) => widget is ProductsWidget && widget.title == section,
      );
      final seeAllButton = find.descendant(
        of: productsWidget,
        matching: find.text('See All'),
      );
      await tester.tap(seeAllButton);
      await tester.pumpAndSettle();

      expect(find.byType(ProductGridWidget), findsOneWidget);
      expect(find.text(section), findsOneWidget);
      expect(find.byType(ProductCard), findsNWidgets(7));
      expect(tester.takeException(), isNull);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('tapping a product opens its details screen', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(260, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pump();

    final featuredSection = find.byWidgetPredicate(
      (widget) => widget is ProductsWidget && widget.title == 'Special',
    );
    await tester.tap(
      find
          .descendant(of: featuredSection, matching: find.byType(ProductCard))
          .first,
    );
    await tester.pumpAndSettle();

    expect(find.byType(ProductDetailsScreen), findsOneWidget);
    expect(find.text('New Year Special Shoe 30'), findsOneWidget);
    final lastImageIndicator = find.byKey(
      const ValueKey('product-image-indicator-3'),
    );
    expect(lastImageIndicator, findsOneWidget);
    await tester.tap(lastImageIndicator);
    await tester.pumpAndSettle();
    expect(
      tester
          .getSemantics(lastImageIndicator)
          .getSemanticsData()
          .flagsCollection
          .isSelected,
      Tristate.isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('each category opens a product grid for that category', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(260, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pump();

    for (final category in ['Electronics', 'Food', 'Fashion', 'Furniture']) {
      await tester.tap(find.text(category));
      await tester.pumpAndSettle();

      expect(find.byType(ProductGridWidget), findsOneWidget);
      expect(find.text(category), findsOneWidget);
      expect(find.byType(ProductCard), findsNWidgets(7));
      expect(tester.takeException(), isNull);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();
    }
  });

  testWidgets('All Categories See All opens the categories grid', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(260, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pump();

    final categoriesSection = find.byWidgetPredicate(
      (widget) => widget is SectionHeader && widget.title == 'All Categories',
    );
    await tester.tap(
      find.descendant(of: categoriesSection, matching: find.text('See All')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CategoriesGridWidget), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.byType(CategoryCard), findsNWidgets(16));
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Food').first);
    await tester.pumpAndSettle();
    expect(find.byType(ProductGridWidget), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _BrandService extends BrandService {
  @override
  Future<List<BrandModel>> getBrands({int? count, int? page}) async => [
    const BrandModel(title: 'Apple', slug: 'apple'),
    const BrandModel(title: 'Samsung', slug: 'samsung'),
  ];
}

class _CategoryService extends CategoryService {
  @override
  Future<List<CategoryModel>> getCategories({int? count, int? page}) async => [
    const CategoryModel(id: 'category-books', title: 'Books', slug: 'books'),
    const CategoryModel(title: 'Food', slug: 'food'),
  ];
}

class _ProductService extends ProductService {
  String? requestedCategoryId;

  @override
  Future<List<ProductModel>> getProducts({
    int? count,
    int? page,
    String? categoryId,
  }) async {
    requestedCategoryId = categoryId;
    return const [
      ProductModel(
        id: 'product-books',
        title: 'Category Book',
        slug: 'category-book',
        categoryIds: ['category-books'],
        currentPrice: 250,
      ),
    ];
  }
}
