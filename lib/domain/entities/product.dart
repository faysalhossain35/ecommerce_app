class Product {
  const Product({
    this.id,
    required this.title,
    required this.slug,
    this.brandId,
    this.categoryIds = const [],
    this.description,
    this.photos = const [],
    this.colors = const [],
    this.sizes = const [],
    this.tags = const [],
    this.regularPrice,
    this.currentPrice,
    this.quantity = 0,
  });

  final String? id;
  final String title;
  final String slug;
  final String? brandId;
  final List<String> categoryIds;
  final String? description;
  final List<String> photos;
  final List<String> colors;
  final List<String> sizes;
  final List<String> tags;
  final double? regularPrice;
  final double? currentPrice;
  final int quantity;
}
