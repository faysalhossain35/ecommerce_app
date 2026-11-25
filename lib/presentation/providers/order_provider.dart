import 'package:ecommerce_app/data/service/order_service.dart';
import 'package:ecommerce_app/presentation/providers/feature_provider.dart';

class OrderProvider extends FeatureProvider {
  OrderProvider({OrderService? service}) : _service = service ?? OrderService();

  final OrderService _service;
  List<Map<String, dynamic>> _orders = [];

  List<Map<String, dynamic>> get orders => List.unmodifiable(_orders);

  Future<void> fetchOrders() {
    return runOperation(() async {
      _orders = await _service.getOrders();
    });
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> order) {
    return runOperation(() => _service.createOrder(order));
  }

  Future<Map<String, dynamic>> getOrder(String id) {
    return runOperation(() => _service.getOrder(id));
  }

  Future<Map<String, dynamic>> getTransaction() {
    return runOperation(() => _service.getTransaction());
  }

  Future<void> cancelOrder(String id) {
    return runOperation(() async {
      await _service.cancelOrder(id);
      await fetchOrders();
    });
  }
}
