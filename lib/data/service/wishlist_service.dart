import 'dart:convert';

import 'package:ecommerce_app/core/constants/end_points.dart';
import 'package:ecommerce_app/data/service/api_service_helpers.dart';
import 'package:ecommerce_app/data/service/network/network_caller.dart';

class WishlistService {
  WishlistService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  final NetworkCaller _networkCaller;

  Future<List<Map<String, dynamic>>> getWishlist() async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.wishlist),
      headers: await buildApiHeaders(authenticated: true),
    );
    return ApiResponseParser.list(response, resourceName: 'wishlist');
  }

  Future<void> addToWishlist(String productId) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.addToWishlist),
      headers: await buildApiHeaders(authenticated: true, jsonBody: true),
      body: jsonEncode({'product': productId}),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Future<void> removeFromWishlist(String productId) async {
    final response = await _networkCaller.delete(
      Uri.parse(EndPoints.wishlistItemById(productId)),
      headers: await buildApiHeaders(authenticated: true),
    );
    ApiResponseParser.ensureSuccess(response);
  }
}
