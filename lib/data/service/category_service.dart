import 'dart:convert';

import 'package:ecommerce_app/core/constants/end_points.dart';
import 'package:ecommerce_app/data/models/category_model.dart';
import 'package:ecommerce_app/data/service/api_service_helpers.dart';
import 'package:ecommerce_app/data/service/network/network_caller.dart';

class CategoryService {
  CategoryService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  final NetworkCaller _networkCaller;

  Future<List<CategoryModel>> getCategories({int? count, int? page}) async {
    final response = await _networkCaller.get(
      buildCollectionUri(EndPoints.categories, count: count, page: page),
      headers: await buildApiHeaders(),
    );
    return ApiResponseParser.list(
      response,
      resourceName: 'categories',
    ).map(CategoryModel.fromJson).toList(growable: false);
  }

  Future<CategoryModel> getCategory(String id) async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.categoryById(id)),
      headers: await buildApiHeaders(),
    );
    return CategoryModel.fromJson(
      ApiResponseParser.object(response, resourceName: 'category'),
    );
  }

  Future<void> createCategory(CategoryModel category) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.createCategory),
      headers: await buildApiHeaders(authenticated: true, jsonBody: true),
      body: jsonEncode(_requestBody(category)),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Future<void> updateCategory(String id, CategoryModel category) async {
    final response = await _networkCaller.patch(
      Uri.parse(EndPoints.updateCategory(id)),
      headers: await buildApiHeaders(authenticated: true, jsonBody: true),
      body: jsonEncode(_requestBody(category)),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Future<void> deleteCategory(String id) async {
    final response = await _networkCaller.delete(
      Uri.parse(EndPoints.deleteCategory(id)),
      headers: await buildApiHeaders(authenticated: true),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Map<String, dynamic> _requestBody(CategoryModel category) =>
      category.toJson()..remove('_id');
}
