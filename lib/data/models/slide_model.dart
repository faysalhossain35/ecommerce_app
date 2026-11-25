import 'package:ecommerce_app/data/models/model_json_helpers.dart';
import 'package:ecommerce_app/domain/entities/slide.dart';

class SlideModel extends Slide {
  const SlideModel({
    super.id,
    required super.photoUrl,
    super.description,
    super.productId,
    super.brandId,
    super.categoryId,
  });

  factory SlideModel.fromJson(Map<String, dynamic> json) {
    return SlideModel(
      id: optionalJsonEntityId(json),
      photoUrl: requiredJsonString(json, 'photo_url'),
      description: optionalJsonString(json, 'description'),
      productId: optionalJsonId(json, 'product'),
      brandId: optionalJsonId(json, 'brand'),
      categoryId: optionalJsonId(json, 'category'),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'photo_url': photoUrl,
    if (description != null) 'description': description,
    if (productId != null) 'product': productId,
    if (brandId != null) 'brand': brandId,
    if (categoryId != null) 'category': categoryId,
  };
}
