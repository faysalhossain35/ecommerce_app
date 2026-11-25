import 'dart:convert';

import 'package:ecommerce_app/core/constants/end_points.dart';
import 'package:ecommerce_app/data/models/auth_models.dart';
import 'package:ecommerce_app/data/service/api_service_helpers.dart';
import 'package:ecommerce_app/data/service/cached/cache_service.dart';
import 'package:ecommerce_app/data/service/network/network_caller.dart';

class AuthService {
  AuthService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  final NetworkCaller _networkCaller;

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.login),
      headers: await buildApiHeaders(jsonBody: true),
      body: jsonEncode({'email': email, 'password': password}),
    );
    final result = AuthResult.fromJson(
      ApiResponseParser.object(response, resourceName: 'auth'),
    );
    if (result.token != null) {
      await CacheService.saveBearerToken(result.token!);
    }
    return result;
  }

  Future<AuthResult> register({
    required String email,
    required String password,
  }) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.register),
      headers: await buildApiHeaders(jsonBody: true),
      body: jsonEncode({'email': email, 'password': password}),
    );
    return AuthResult.fromJson(
      ApiResponseParser.object(response, resourceName: 'auth'),
    );
  }

  Future<AuthResult> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.verifyOtp),
      headers: await buildApiHeaders(jsonBody: true),
      body: jsonEncode({'email': email, 'otp': otp}),
    );
    final result = AuthResult.fromJson(
      ApiResponseParser.object(response, resourceName: 'auth'),
    );
    if (result.token != null) {
      await CacheService.saveBearerToken(result.token!);
    }
    return result;
  }

  Future<void> resendOtp(String email) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.resendOtp),
      headers: await buildApiHeaders(jsonBody: true),
      body: jsonEncode({'email': email}),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.profile),
      headers: await buildApiHeaders(authenticated: true),
    );
    return ApiResponseParser.object(response, resourceName: 'profile');
  }

  Future<void> logout() => CacheService.clearBearerToken();
}
