import 'dart:convert';

import 'package:ecommerce_app/core/constants/end_points.dart';
import 'package:ecommerce_app/data/models/brand_model.dart';
import 'package:ecommerce_app/data/service/api_service_helpers.dart';
import 'package:ecommerce_app/data/service/network/network_caller.dart';

class BrandService {
  BrandService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  final NetworkCaller _networkCaller;

  Future<List<BrandModel>> getBrands({int? count, int? page}) async {
    final response = await _networkCaller.get(
      buildCollectionUri(EndPoints.brands, count: count, page: page),
      headers: await buildApiHeaders(),
    );
    return ApiResponseParser.list(
      response,
      resourceName: 'brands',
    ).map(BrandModel.fromJson).toList(growable: false);
  }

  Future<BrandModel> getBrand(String id) async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.brandById(id)),
      headers: await buildApiHeaders(),
    );
    return BrandModel.fromJson(
      ApiResponseParser.object(response, resourceName: 'brand'),
    );
  }

  Future<void> createBrand(BrandModel brand) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.createBrand),
      headers: await buildApiHeaders(authenticated: true, jsonBody: true),
      body: jsonEncode(_requestBody(brand)),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Future<void> updateBrand(String id, BrandModel brand) async {
    final response = await _networkCaller.patch(
      Uri.parse(EndPoints.updateBrand(id)),
      headers: await buildApiHeaders(authenticated: true, jsonBody: true),
      body: jsonEncode(_requestBody(brand)),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Future<void> deleteBrand(String id) async {
    final response = await _networkCaller.delete(
      Uri.parse(EndPoints.deleteBrand(id)),
      headers: await buildApiHeaders(authenticated: true),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Map<String, dynamic> _requestBody(BrandModel brand) =>
      brand.toJson()..remove('_id');
}
