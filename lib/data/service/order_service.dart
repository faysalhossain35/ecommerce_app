import 'dart:convert';

import 'package:ecommerce_app/core/constants/end_points.dart';
import 'package:ecommerce_app/data/service/api_service_helpers.dart';
import 'package:ecommerce_app/data/service/network/network_caller.dart';

class OrderService {
  OrderService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  final NetworkCaller _networkCaller;

  Future<List<Map<String, dynamic>>> getOrders() async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.orders),
      headers: await buildApiHeaders(authenticated: true),
    );
    return ApiResponseParser.list(response, resourceName: 'orders');
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> order) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.createOrder),
      headers: await buildApiHeaders(authenticated: true, jsonBody: true),
      body: jsonEncode(order),
    );
    return ApiResponseParser.object(response, resourceName: 'order');
  }

  Future<Map<String, dynamic>> getOrder(String id) async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.orderById(id)),
      headers: await buildApiHeaders(authenticated: true),
    );
    return ApiResponseParser.object(response, resourceName: 'order');
  }

  Future<void> cancelOrder(String id) async {
    final response = await _networkCaller.patch(
      Uri.parse(EndPoints.cancelOrder(id)),
      headers: await buildApiHeaders(authenticated: true),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Future<Map<String, dynamic>> getTransaction() async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.orderTransaction),
      headers: await buildApiHeaders(authenticated: true),
    );
    return ApiResponseParser.object(response, resourceName: 'transaction');
  }
}
