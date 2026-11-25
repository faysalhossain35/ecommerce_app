import 'package:ecommerce_app/data/service/cart_service.dart';
import 'package:ecommerce_app/presentation/providers/feature_provider.dart';

class CartProvider extends FeatureProvider {
  CartProvider({CartService? service}) : _service = service ?? CartService();

  final CartService _service;
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => List.unmodifiable(_items);

  Future<void> fetchCart() {
    return runOperation(() async {
      _items = await _service.getCart();
    });
  }

  Future<void> addToCart(Map<String, dynamic> item) {
    return runOperation(() async {
      await _service.addToCart(item);
      await fetchCart();
    });
  }

  Future<void> updateCartItem(String id, int quantity) {
    return runOperation(() async {
      await _service.updateCartItem(id, quantity);
      await fetchCart();
    });
  }

  Future<void> deleteCartItem(String id) {
    return runOperation(() async {
      await _service.deleteCartItem(id);
      await fetchCart();
    });
  }
}
