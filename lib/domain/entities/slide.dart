class Slide {
  const Slide({
    this.id,
    required this.photoUrl,
    this.description,
    this.productId,
    this.brandId,
    this.categoryId,
  });

  final String? id;
  final String photoUrl;
  final String? description;
  final String? productId;
  final String? brandId;
  final String? categoryId;
}
