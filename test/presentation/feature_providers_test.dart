import 'dart:async';

import 'package:ecommerce_app/data/models/brand_model.dart';
import 'package:ecommerce_app/data/models/category_model.dart';
import 'package:ecommerce_app/data/models/slide_model.dart';
import 'package:ecommerce_app/data/service/brand_service.dart';
import 'package:ecommerce_app/data/service/category_service.dart';
import 'package:ecommerce_app/data/service/slide_service.dart';
import 'package:ecommerce_app/presentation/pages/brand/providers/brand_provider.dart';
import 'package:ecommerce_app/presentation/pages/category/providers/category_provider.dart';
import 'package:ecommerce_app/presentation/pages/slide/providers/slide_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('feature providers expose fetched entities and loading state', () async {
    final brandsResult = Completer<List<BrandModel>>();
    final brandProvider = BrandProvider(
      service: _BrandService(() => brandsResult.future),
    );
    final brandFetch = brandProvider.fetchBrands(count: 5, page: 1);
    expect(brandProvider.isLoading, isTrue);
    brandsResult.complete([const BrandModel(title: 'Brand', slug: 'brand')]);
    await brandFetch;
    expect(brandProvider.brands.single.title, 'Brand');
    expect(brandProvider.isLoading, isFalse);

    final categoryService = _CategoryService(
      () async => [const CategoryModel(title: 'Category', slug: 'category')],
    );
    final categoryProvider = CategoryProvider(service: categoryService);
    await categoryProvider.fetchCategories();
    expect(categoryProvider.categories.single.title, 'Category');
    expect(categoryService.requestedCount, 100);

    final slideProvider = SlideProvider(
      service: _SlideService(
        () async => [
          const SlideModel(photoUrl: 'https://example.com/slide.png'),
        ],
      ),
    );
    await slideProvider.fetchSlides();
    expect(
      slideProvider.slides.single.photoUrl,
      'https://example.com/slide.png',
    );

    brandProvider.dispose();
    categoryProvider.dispose();
    slideProvider.dispose();
  });

  test('feature provider stores errors and resets loading state', () async {
    final provider = BrandProvider(
      service: _BrandService(() async => throw Exception('request failed')),
    );
    addTearDown(provider.dispose);

    await expectLater(provider.fetchBrands(), throwsException);

    expect(provider.errorMessage, contains('request failed'));
    expect(provider.isLoading, isFalse);
  });
}

class _BrandService extends BrandService {
  _BrandService(this._fetch) : super();

  final Future<List<BrandModel>> Function() _fetch;

  @override
  Future<List<BrandModel>> getBrands({int? count, int? page}) => _fetch();
}

class _CategoryService extends CategoryService {
  _CategoryService(this._fetch) : super();

  final Future<List<CategoryModel>> Function() _fetch;
  int? requestedCount;

  @override
  Future<List<CategoryModel>> getCategories({int? count, int? page}) {
    requestedCount = count;
    return _fetch();
  }
}

class _SlideService extends SlideService {
  _SlideService(this._fetch) : super();

  final Future<List<SlideModel>> Function() _fetch;

  @override
  Future<List<SlideModel>> getSlides({int? count, int? page}) => _fetch();
}
