import 'package:ecommerce_app/data/models/model_json_helpers.dart';
import 'package:ecommerce_app/domain/entities/brand.dart';

class BrandModel extends Brand {
  const BrandModel({
    super.id,
    required super.title,
    required super.slug,
    super.description,
    super.icon,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: optionalJsonEntityId(json),
      title: requiredJsonString(json, 'title'),
      slug: requiredJsonString(json, 'slug'),
      description: optionalJsonString(json, 'description'),
      icon: optionalJsonString(json, 'icon'),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'title': title,
    'slug': slug,
    if (description != null) 'description': description,
    if (icon != null) 'icon': icon,
  };
}
