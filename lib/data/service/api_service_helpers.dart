import 'dart:convert';

import 'package:ecommerce_app/data/service/cached/cache_service.dart';
import 'package:ecommerce_app/data/service/network/network_response.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiResponseParser {
  static void ensureSuccess(NetworkResponse response) {
    if (response.isSuccess == true) return;
    throw ApiException(_errorMessage(response));
  }

  static List<Map<String, dynamic>> list(
    NetworkResponse response, {
    required String resourceName,
  }) {
    final payload = _unwrap(decode(response), resourceName);
    if (payload is Map) {
      final map = _asJsonMap(payload, resourceName);
      if (map['results'] is List) {
        return (map['results'] as List)
            .map((item) => _asJsonMap(item, resourceName))
            .toList(growable: false);
      }
      for (final key in ['items', resourceName]) {
        if (map[key] is List) {
          return (map[key] as List)
              .map((item) => _asJsonMap(item, resourceName))
              .toList(growable: false);
        }
      }
    }
    if (payload is! List) {
      throw ApiException('Expected "$resourceName" response to be a list.');
    }
    return payload
        .map((item) => _asJsonMap(item, resourceName))
        .toList(growable: false);
  }

  static Map<String, dynamic> object(
    NetworkResponse response, {
    required String resourceName,
  }) {
    final payload = _unwrap(decode(response), resourceName);
    return _asJsonMap(payload, resourceName);
  }

  static Object? decode(NetworkResponse response) {
    ensureSuccess(response);
    final body = response.body;
    if (body == null || body.trim().isEmpty) return null;
    try {
      return jsonDecode(body);
    } on FormatException catch (error) {
      throw ApiException('Server returned invalid JSON: ${error.message}');
    }
  }

  static Object? _unwrap(Object? payload, String resourceName) {
    if (payload is Map && payload.containsKey('data')) {
      payload = payload['data'];
    } else if (payload is Map && payload.containsKey(resourceName)) {
      payload = payload[resourceName];
    }
    if (payload is Map && payload.containsKey(resourceName)) {
      payload = payload[resourceName];
    }
    return payload;
  }

  static Map<String, dynamic> _asJsonMap(Object? value, String resourceName) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      final result = <String, dynamic>{};
      for (final entry in value.entries) {
        final key = entry.key;
        if (key is! String) {
          throw ApiException(
            'Expected "$resourceName" response fields to have string keys.',
          );
        }
        result[key] = entry.value;
      }
      return result;
    }
    throw ApiException('Expected "$resourceName" response to be an object.');
  }

  static String _errorMessage(NetworkResponse response) {
    final body = response.body;
    if (body != null && body.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map) {
          final message = decoded['message'] ?? decoded['error'];
          if (message is String && message.trim().isNotEmpty) return message;
        } else if (decoded is String && decoded.trim().isNotEmpty) {
          return decoded;
        }
      } on FormatException {
        // Use the network error message when the server body is not JSON.
      }
    }
    return response.errorMessage ??
        'Request failed with status ${response.statusCode}.';
  }
}

Future<Map<String, String>> buildApiHeaders({
  bool authenticated = false,
  bool jsonBody = false,
}) async {
  final headers = <String, String>{'Accept': 'application/json'};
  if (jsonBody) headers['Content-Type'] = 'application/json';
  if (authenticated) {
    final token = await CacheService.getBearerToken();
    if (token == null || token.trim().isEmpty) {
      throw const ApiException('A saved bearer token is required.');
    }
    headers['token'] = token.trim();
  }
  return headers;
}

Uri buildCollectionUri(String endpoint, {int? count, int? page}) {
  final queryParameters = <String, String>{
    if (count != null) 'count': '$count',
    if (page != null) 'page': '$page',
  };
  final uri = Uri.parse(endpoint);
  return queryParameters.isEmpty
      ? uri
      : uri.replace(queryParameters: queryParameters);
}
