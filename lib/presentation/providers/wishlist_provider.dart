import 'package:ecommerce_app/data/service/wishlist_service.dart';
import 'package:ecommerce_app/presentation/providers/feature_provider.dart';

class WishlistProvider extends FeatureProvider {
  WishlistProvider({WishlistService? service})
    : _service = service ?? WishlistService();

  final WishlistService _service;
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => List.unmodifiable(_items);

  Future<void> fetchWishlist() {
    return runOperation(() async {
      _items = await _service.getWishlist();
    });
  }

  Future<void> addToWishlist(String productId) {
    return runOperation(() async {
      await _service.addToWishlist(productId);
      await fetchWishlist();
    });
  }

  Future<void> removeFromWishlist(String productId) {
    return runOperation(() async {
      await _service.removeFromWishlist(productId);
      await fetchWishlist();
    });
  }
}
