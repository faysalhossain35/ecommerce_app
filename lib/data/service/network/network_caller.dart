import 'dart:async';
import 'dart:io';

import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:ecommerce_app/data/service/network/networker_log_box.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'network_response.dart';

/// The only class in the app that talks to the `http` package.
///
/// It sends requests, prints request and response details to the debug console,
/// and turns every outcome (success, bad status, timeout, no internet) into a
/// [NetworkResponse]. It knows nothing about entities or JSON shapes; that
/// belongs to the feature services above it.
class NetworkCaller {
  static const Duration _timeout = Duration(seconds: 20);

  // Logger's default filter prints in debug builds only, so release builds stay silent.
  // No box borders or colors: they render as garbage in some consoles.
  final _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      colors: false,
      printEmojis: false,
      noBoxingByDefault: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );

  /// Sends a GET request to [uri].
  Future<NetworkResponse> get(Uri uri, {Map<String, String>? headers}) {
    return _send(
      method: 'GET',
      uri: uri,
      headers: headers,
      request: () => http.get(uri, headers: headers),
    );
  }

  /// Sends a POST request to [uri].
  Future<NetworkResponse> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _send(
      method: 'POST',
      uri: uri,
      headers: headers,
      request: () => http.post(uri, headers: headers, body: body),
    );
  }

  /// Sends a PATCH request to [uri].
  Future<NetworkResponse> patch(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _send(
      method: 'PATCH',
      uri: uri,
      headers: headers,
      request: () => http.patch(uri, headers: headers, body: body),
    );
  }

  /// Sends a DELETE request to [uri].
  Future<NetworkResponse> delete(Uri uri, {Map<String, String>? headers}) {
    return _send(
      method: 'DELETE',
      uri: uri,
      headers: headers,
      request: () => http.delete(uri, headers: headers),
    );
  }

  Future<NetworkResponse> _send({
    required String method,
    required Uri uri,
    required Future<http.Response> Function() request,
    Map<String, String>? headers,
  }) async {
    _logger.i(NetworkLogBox.request(method, uri, headers));
    final stopwatch = Stopwatch()..start();
    try {
      final response = await request().timeout(_timeout);
      _logResponse(method, response, stopwatch.elapsedMilliseconds);
      return _toNetworkResponse(response);
    } on TimeoutException {
      _logError(method, uri, AppStrings.networkTimeoutError, stopwatch);
      return _failure(AppStrings.networkTimeoutError);
    } on SocketException {
      _logError(method, uri, AppStrings.networkNoInternetError, stopwatch);
      return _failure(AppStrings.networkNoInternetError);
    } catch (e, stackTrace) {
      _logError(
        method,
        uri,
        '${AppStrings.networkUnexpectedError} ($e)',
        stopwatch,
      );
      _logger.e('', stackTrace: stackTrace);
      return _failure(AppStrings.networkUnexpectedError);
    }
  }

  void _logResponse(String method, http.Response response, int elapsedMs) {
    final message = NetworkLogBox.response(
      method: method,
      uri: response.request?.url,
      statusCode: response.statusCode,
      reason: response.reasonPhrase,
      elapsedMs: elapsedMs,
      body: response.body,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      _logger.d(message);
    } else {
      _logger.e(message);
    }
  }

  void _logError(String method, Uri uri, String message, Stopwatch stopwatch) {
    _logger.w(
      NetworkLogBox.error(method, uri, message, stopwatch.elapsedMilliseconds),
    );
  }

  NetworkResponse _toNetworkResponse(http.Response response) {
    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;
    return NetworkResponse(
      isSuccess: isSuccess,
      statusCode: response.statusCode,
      body: response.body,
      errorMessage: isSuccess
          ? null
          : '${AppStrings.networkServerError} ${response.statusCode}',
    );
  }

  NetworkResponse _failure(String message) {
    return NetworkResponse(
      isSuccess: false,
      statusCode: -1,
      errorMessage: message,
    );
  }
}
