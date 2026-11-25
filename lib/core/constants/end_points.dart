import 'package:flutter_dotenv/flutter_dotenv.dart';

class EndPoints {
  static String get baseUrl {
    if (!dotenv.isInitialized) {
      throw StateError('Load the .env file before accessing API endpoints.');
    }

    final value = dotenv.env['BASE_URL']?.trim();
    if (value == null || value.isEmpty) {
      throw StateError('BASE_URL is missing from the .env file.');
    }
    return value;
  }

  static String get login => '$baseUrl/auth/login';
  static String get signup => '$baseUrl/auth/signup';
  static String get register => signup;
  static String get verifyOtp => '$baseUrl/auth/verify-otp';
  static String get resendOtp => '$baseUrl/auth/resend-otp';
  static String get profile => '$baseUrl/auth/profile';

  static String get brands => '$baseUrl/brands';
  static String brandById(String id) => '$brands/${_pathSegment(id)}';
  static String get createBrand => '$baseUrl/brand';
  static String updateBrand(String id) => brandById(id);
  static String deleteBrand(String id) => brandById(id);

  static String get categories => '$baseUrl/categories';
  static String categoryById(String id) => '$categories/${_pathSegment(id)}';
  static String get createCategory => '$baseUrl/category';
  static String updateCategory(String id) => categoryById(id);
  static String deleteCategory(String id) => categoryById(id);

  static String get products => '$baseUrl/products';
  static String productBySlug(String slug) => '$products/${_pathSegment(slug)}';
  static String productById(String id) => '$products/id/${_pathSegment(id)}';
  static String get createProduct => '$baseUrl/product';
  static String updateProduct(String id) => '$products/${_pathSegment(id)}';
  static String deleteProduct(String id) => updateProduct(id);

  static String get reviews => '$baseUrl/reviews';
  static String get createReview => '$baseUrl/review';
  static String reviewById(String id) => '$reviews/${_pathSegment(id)}';
  static String updateReview(String id) => reviewById(id);
  static String deleteReview(String id) => reviewById(id);

  static String get cart => '$baseUrl/cart';
  static String get addToCart => cart;
  static String cartItemById(String id) => '$cart/${_pathSegment(id)}';
  static String updateCartItem(String id) => cartItemById(id);
  static String deleteCartItem(String id) => cartItemById(id);

  static String get wishlist => '$baseUrl/wishlist';
  static String get addToWishlist => wishlist;
  static String wishlistItemById(String id) => '$wishlist/${_pathSegment(id)}';
  static String deleteWishlistItem(String id) => wishlistItemById(id);

  static String get orders => '$baseUrl/orders';
  static String orderById(String id) => '$orders/${_pathSegment(id)}';
  static String get createOrder => '$baseUrl/order';
  static String cancelOrder(String id) => '${orderById(id)}/cancel';
  static String updateOrder(String id) => orderById(id);
  static String get orderTransaction => '$orders/transaction';
  static String deleteOrder(String id) => orderById(id);

  static String get slides => '$baseUrl/slides';
  static String get createSlide => '$baseUrl/slide';
  static String slideById(String id) => '$slides/${_pathSegment(id)}';
  static String deleteSlide(String id) => slideById(id);

  static String _pathSegment(String value) => Uri.encodeComponent(value);
}
