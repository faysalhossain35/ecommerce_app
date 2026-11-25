import 'dart:convert';

import 'package:ecommerce_app/core/constants/end_points.dart';
import 'package:ecommerce_app/data/service/api_service_helpers.dart';
import 'package:ecommerce_app/data/service/network/network_caller.dart';

class ReviewService {
  ReviewService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  final NetworkCaller _networkCaller;

  Future<List<Map<String, dynamic>>> getReviews(String productId) async {
    final uri = Uri.parse(EndPoints.reviews)
        .replace(queryParameters: {'product': productId});
    final response = await _networkCaller.get(
      uri,
      headers: await buildApiHeaders(),
    );
    return ApiResponseParser.list(response, resourceName: 'reviews');
  }

  Future<void> createReview(Map<String, dynamic> review) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.createReview),
      headers: await buildApiHeaders(authenticated: true, jsonBody: true),
      body: jsonEncode(review),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Future<void> updateReview(String id, Map<String, dynamic> review) async {
    final response = await _networkCaller.patch(
      Uri.parse(EndPoints.updateReview(id)),
      headers: await buildApiHeaders(authenticated: true, jsonBody: true),
      body: jsonEncode(review),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Future<void> deleteReview(String id) async {
    final response = await _networkCaller.delete(
      Uri.parse(EndPoints.deleteReview(id)),
      headers: await buildApiHeaders(authenticated: true),
    );
    ApiResponseParser.ensureSuccess(response);
  }
}
