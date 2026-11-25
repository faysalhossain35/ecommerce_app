import 'package:ecommerce_app/data/models/product_model.dart';
import 'package:ecommerce_app/data/service/product_service.dart';
import 'package:ecommerce_app/domain/entities/product.dart';
import 'package:ecommerce_app/presentation/providers/feature_provider.dart';

class ProductProvider extends FeatureProvider {
  ProductProvider({ProductService? service})
    : _service = service ?? ProductService();

  final ProductService _service;
  List<Product> _products = [];

  List<Product> get products => List.unmodifiable(_products);

  Future<void> fetchProducts({int? count, int? page, String? categoryId}) {
    return runOperation(() async {
      _products = await _service.getProducts(
        count: count,
        page: page,
        categoryId: categoryId,
      );
    });
  }

  Future<ProductModel> fetchProductBySlug(String slug) {
    return runOperation(() => _service.getProductBySlug(slug));
  }

  Future<ProductModel> fetchProductById(String id) {
    return runOperation(() => _service.getProductById(id));
  }

  Future<void> createProduct(ProductModel product) {
    return runOperation(() async {
      await _service.createProduct(product);
      await fetchProducts();
    });
  }

  Future<void> updateProduct(String id, ProductModel product) {
    return runOperation(() async {
      await _service.updateProduct(id, product);
      await fetchProducts();
    });
  }

  Future<void> deleteProduct(String id) {
    return runOperation(() async {
      await _service.deleteProduct(id);
      _products = _products.where((product) => product.id != id).toList();
    });
  }
}
