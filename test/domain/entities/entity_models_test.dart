import 'package:ecommerce_app/data/models/brand_model.dart';
import 'package:ecommerce_app/data/models/category_model.dart';
import 'package:ecommerce_app/data/models/slide_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BrandModel parses and serializes API fields', () {
    final brand = BrandModel.fromJson({
      '_id': 'brand-1',
      'title': 'Brand',
      'slug': 'brand',
      'description': 'Description',
      'icon': 'https://example.com/brand.png',
    });

    expect(brand.id, 'brand-1');
    expect(brand.toJson(), {
      '_id': 'brand-1',
      'title': 'Brand',
      'slug': 'brand',
      'description': 'Description',
      'icon': 'https://example.com/brand.png',
    });
  });

  test('CategoryModel parses populated parent IDs', () {
    final category = CategoryModel.fromJson({
      'id': 'category-1',
      'title': 'Category',
      'slug': 'category',
      'parent': {'_id': 'parent-1'},
    });

    expect(category.id, 'category-1');
    expect(category.description, isNull);
    expect(category.parentId, 'parent-1');
    expect(category.toJson(), {
      '_id': 'category-1',
      'title': 'Category',
      'slug': 'category',
      'parent': 'parent-1',
    });
  });

  test('SlideModel maps API relation fields to IDs', () {
    final slide = SlideModel.fromJson({
      '_id': 'slide-1',
      'photo_url': 'https://example.com/slide.png',
      'description': 'Featured slide',
      'product': 'product-1',
      'brand': {'id': 'brand-1'},
      'category': null,
    });

    expect(slide.productId, 'product-1');
    expect(slide.brandId, 'brand-1');
    expect(slide.categoryId, isNull);
    expect(slide.toJson(), {
      '_id': 'slide-1',
      'photo_url': 'https://example.com/slide.png',
      'description': 'Featured slide',
      'product': 'product-1',
      'brand': 'brand-1',
    });
  });

  test('required API strings reject missing or empty values', () {
    expect(() => BrandModel.fromJson({'slug': 'brand'}), throwsFormatException);
    expect(
      () => SlideModel.fromJson({'photo_url': '  '}),
      throwsFormatException,
    );
  });
}
