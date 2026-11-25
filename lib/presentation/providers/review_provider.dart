import 'package:ecommerce_app/data/service/review_service.dart';
import 'package:ecommerce_app/presentation/providers/feature_provider.dart';

class ReviewProvider extends FeatureProvider {
  ReviewProvider({ReviewService? service})
    : _service = service ?? ReviewService();

  final ReviewService _service;
  List<Map<String, dynamic>> _reviews = [];

  List<Map<String, dynamic>> get reviews => List.unmodifiable(_reviews);

  Future<void> fetchReviews(String productId) {
    return runOperation(() async {
      _reviews = await _service.getReviews(productId);
    });
  }

  Future<void> createReview(Map<String, dynamic> review) {
    return runOperation(() async {
      await _service.createReview(review);
      final productId = review['product']?.toString();
      if (productId != null) await fetchReviews(productId);
    });
  }
}
