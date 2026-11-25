import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ecommerce_app/data/models/brand_model.dart';
import 'package:ecommerce_app/data/service/product_service.dart';
import 'package:ecommerce_app/data/service/brand_service.dart';
import 'package:ecommerce_app/data/service/cached/cache_service.dart';
import 'package:ecommerce_app/data/service/category_service.dart';
import 'package:ecommerce_app/data/service/slide_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'feature services parse lists and authenticate create requests',
    () async {
      SharedPreferences.setMockInitialValues({});
      await CacheService.saveBearerToken('test-token');

      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));

      final brandListUri = Completer<Uri>();
      final productListUri = Completer<Uri>();
      final createBrandRequest = Completer<List<Object?>>();
      server.listen((request) async {
        switch ('${request.method} ${request.uri.path}') {
          case 'GET /api/brands':
            brandListUri.complete(request.uri);
            request.response.write(
              jsonEncode({
                'data': {
                  'brands': [
                    {
                      '_id': 'brand-1',
                      'title': 'Brand',
                      'slug': 'brand',
                      'icon': 'https://example.com/brand.png',
                    },
                  ],
                },
              }),
            );
          case 'GET /api/categories':
            request.response.write(
              jsonEncode({
                'data': {
                  'results': [
                    {
                      '_id': 'category-1',
                      'title': 'Category',
                      'slug': 'category',
                    },
                  ],
                  'total': 1,
                  'next': null,
                },
              }),
            );
          case 'GET /api/slides':
            request.response.write(
              jsonEncode({
                'data': {
                  'slides': [
                    {
                      '_id': 'slide-1',
                      'photo_url': 'https://example.com/slide.png',
                    },
                  ],
                },
              }),
            );
          case 'GET /api/products':
            productListUri.complete(request.uri);
            request.response.write(
              jsonEncode({
                'data': {
                  'results': [
                    {
                      '_id': 'product-1',
                      'title': 'Category Product',
                      'slug': 'category-product',
                      'categories': ['category-1'],
                      'photos': [],
                      'current_price': 250,
                    },
                  ],
                },
              }),
            );
          case 'POST /api/brand':
            final body = await utf8.decoder.bind(request).join();
            createBrandRequest.complete([
              request.headers.value('token'),
              jsonDecode(body),
            ]);
            request.response.statusCode = HttpStatus.created;
          default:
            request.response.statusCode = HttpStatus.notFound;
        }
        await request.response.close();
      });

      dotenv.loadFromString(
        envString:
            'BASE_URL=http://${server.address.address}:${server.port}/api',
      );

      final brands = await BrandService().getBrands(count: 2, page: 1);
      final categories = await CategoryService().getCategories();
      final slides = await SlideService().getSlides();
      final products = await ProductService().getProducts(
        count: 100,
        categoryId: 'category-1',
      );
      await BrandService().createBrand(
        const BrandModel(
          id: 'local-only-id',
          title: 'New Brand',
          slug: 'new-brand',
        ),
      );

      expect(brands.single.id, 'brand-1');
      final requestUri = await brandListUri.future;
      expect(requestUri.queryParameters, {'count': '2', 'page': '1'});
      expect(categories.single.title, 'Category');
      expect(slides.single.photoUrl, 'https://example.com/slide.png');
      expect(products.single.title, 'Category Product');
      expect((await productListUri.future).queryParameters, {
        'count': '100',
        'category': 'category-1',
      });
      final request = await createBrandRequest.future;
      expect(request[0], 'test-token');
      expect(request[1], {'title': 'New Brand', 'slug': 'new-brand'});
    },
  );
}
