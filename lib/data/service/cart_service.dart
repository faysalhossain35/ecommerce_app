import 'dart:convert';

import 'package:ecommerce_app/core/constants/end_points.dart';
import 'package:ecommerce_app/data/service/api_service_helpers.dart';
import 'package:ecommerce_app/data/service/network/network_caller.dart';

class CartService {
  CartService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  final NetworkCaller _networkCaller;

  Future<List<Map<String, dynamic>>> getCart() async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.cart),
      headers: await buildApiHeaders(authenticated: true),
    );
    return ApiResponseParser.list(response, resourceName: 'cart');
  }

  Future<void> addToCart(Map<String, dynamic> item) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.addToCart),
      headers: await buildApiHeaders(authenticated: true, jsonBody: true),
      body: jsonEncode(item),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Future<void> updateCartItem(String id, int quantity) async {
    final response = await _networkCaller.patch(
      Uri.parse(EndPoints.updateCartItem(id)),
      headers: await buildApiHeaders(authenticated: true, jsonBody: true),
      body: jsonEncode({'quantity': quantity}),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Future<void> deleteCartItem(String id) async {
    final response = await _networkCaller.delete(
      Uri.parse(EndPoints.deleteCartItem(id)),
      headers: await buildApiHeaders(authenticated: true),
    );
    ApiResponseParser.ensureSuccess(response);
  }
}
