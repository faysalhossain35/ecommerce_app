import 'package:ecommerce_app/core/constants/end_points.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: '.env');
  });

  test('builds core API URLs from the configured base URL', () {
    const baseUrl = 'https://ecom-rs8e.onrender.com/api';

    expect(EndPoints.baseUrl, baseUrl);
    expect(EndPoints.login, '$baseUrl/auth/login');
    expect(EndPoints.register, '$baseUrl/auth/signup');
    expect(EndPoints.products, '$baseUrl/products');
  });

  test('encodes dynamic URL path segments', () {
    expect(
      EndPoints.productBySlug('shoe/blue'),
      endsWith('products/shoe%2Fblue'),
    );
    expect(EndPoints.brandById('brand/123'), endsWith('brands/brand%2F123'));
  });
}
