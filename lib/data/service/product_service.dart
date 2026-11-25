import 'dart:convert';

import 'package:ecommerce_app/core/constants/end_points.dart';
import 'package:ecommerce_app/data/models/product_model.dart';
import 'package:ecommerce_app/data/service/api_service_helpers.dart';
import 'package:ecommerce_app/data/service/network/network_caller.dart';

class ProductService {
  ProductService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  final NetworkCaller _networkCaller;

  Future<List<ProductModel>> getProducts({
    int? count,
    int? page,
    String? categoryId,
  }) async {
    var uri = buildCollectionUri(EndPoints.products, count: count, page: page);
    if (categoryId != null) {
      uri = uri.replace(
        queryParameters: {...uri.queryParameters, 'category': categoryId},
      );
    }
    final response = await _networkCaller.get(
      uri,
      headers: await buildApiHeaders(),
    );
    return ApiResponseParser.list(
      response,
      resourceName: 'products',
    ).map(ProductModel.fromJson).toList(growable: false);
  }

  Future<ProductModel> getProductBySlug(String slug) async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.productBySlug(slug)),
      headers: await buildApiHeaders(),
    );
    return ProductModel.fromJson(
      ApiResponseParser.object(response, resourceName: 'product'),
    );
  }

  Future<ProductModel> getProductById(String id) async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.productById(id)),
      headers: await buildApiHeaders(),
    );
    return ProductModel.fromJson(
      ApiResponseParser.object(response, resourceName: 'product'),
    );
  }

  Future<void> createProduct(ProductModel product) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.createProduct),
      headers: await buildApiHeaders(authenticated: true, jsonBody: true),
      body: jsonEncode(product.toJson()..remove('_id')),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Future<void> updateProduct(String id, ProductModel product) async {
    final response = await _networkCaller.patch(
      Uri.parse(EndPoints.updateProduct(id)),
      headers: await buildApiHeaders(authenticated: true, jsonBody: true),
      body: jsonEncode(product.toJson()..remove('_id')),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Future<void> deleteProduct(String id) async {
    final response = await _networkCaller.delete(
      Uri.parse(EndPoints.deleteProduct(id)),
      headers: await buildApiHeaders(authenticated: true),
    );
    ApiResponseParser.ensureSuccess(response);
  }
}
