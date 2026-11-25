import 'package:ecommerce_app/data/service/cached/cache_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('saves and retrieves the bearer token', () async {
    const token = 'sample-token';

    await CacheService.saveBearerToken(token);

    expect(await CacheService.getBearerToken(), token);
  });

  test('clears the saved bearer token', () async {
    await CacheService.saveBearerToken('sample-token');

    await CacheService.clearBearerToken();

    expect(await CacheService.getBearerToken(), isNull);
  });
}
