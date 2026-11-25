import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ecommerce_app/data/service/network/network_caller.dart';
import 'package:ecommerce_app/data/service/network/networker_log_box.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('POST sends headers and body and maps the server response', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));

    final requestReceived = Completer<HttpRequest>();
    server.listen(requestReceived.complete);

    const requestBody = '{"name":"Ada"}';
    const responseBody = '{"created":true}';
    final responseFuture = NetworkCaller().post(
      Uri(
        scheme: 'http',
        host: server.address.address,
        port: server.port,
        path: '/users',
      ),
      headers: const {'content-type': 'application/json'},
      body: requestBody,
    );

    final request = await requestReceived.future.timeout(
      const Duration(seconds: 5),
    );
    final receivedBody = await utf8.decoder.bind(request).join();
    request.response
      ..statusCode = HttpStatus.created
      ..write(responseBody);
    await request.response.close();

    final response = await responseFuture;

    expect(request.method, 'POST');
    expect(request.headers.contentType?.mimeType, 'application/json');
    expect(receivedBody, requestBody);
    expect(response.isSuccess, isTrue);
    expect(response.statusCode, HttpStatus.created);
    expect(response.body, responseBody);
    expect(response.errorMessage, isNull);
  });

  test('PATCH and DELETE send their HTTP methods', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() => server.close(force: true));

    final patchReceived = Completer<HttpRequest>();
    final deleteReceived = Completer<HttpRequest>();
    server.listen((request) {
      if (request.method == 'PATCH') {
        patchReceived.complete(request);
      } else {
        deleteReceived.complete(request);
      }
    });

    final caller = NetworkCaller();
    final patchFuture = caller.patch(
      Uri(
        scheme: 'http',
        host: server.address.address,
        port: server.port,
        path: '/brands/brand-1',
      ),
      headers: const {'content-type': 'application/json'},
      body: '{"title":"Updated"}',
    );
    final patchRequest = await patchReceived.future.timeout(
      const Duration(seconds: 5),
    );
    final patchBody = await utf8.decoder.bind(patchRequest).join();
    patchRequest.response
      ..statusCode = HttpStatus.ok
      ..write('{"updated":true}');
    await patchRequest.response.close();

    final patchResponse = await patchFuture;
    expect(patchRequest.method, 'PATCH');
    expect(patchBody, '{"title":"Updated"}');
    expect(patchResponse.isSuccess, isTrue);

    final deleteFuture = caller.delete(
      Uri(
        scheme: 'http',
        host: server.address.address,
        port: server.port,
        path: '/brands/brand-1',
      ),
    );
    final deleteRequest = await deleteReceived.future.timeout(
      const Duration(seconds: 5),
    );
    deleteRequest.response.statusCode = HttpStatus.noContent;
    await deleteRequest.response.close();

    final deleteResponse = await deleteFuture;
    expect(deleteRequest.method, 'DELETE');
    expect(deleteResponse.isSuccess, isTrue);
  });

  test('request logs redact authentication headers', () {
    final log = NetworkLogBox.request(
      'GET',
      Uri.parse('https://example.com'),
      const {'token': 'secret-token', 'Authorization': 'Bearer secret-token'},
    );

    expect(log, contains('[REDACTED]'));
    expect(log, isNot(contains('secret-token')));
  });
}
