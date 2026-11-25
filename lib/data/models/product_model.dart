import 'package:ecommerce_app/data/models/model_json_helpers.dart';
import 'package:ecommerce_app/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    super.id,
    required super.title,
    required super.slug,
    super.brandId,
    super.categoryIds,
    super.description,
    super.photos,
    super.colors,
    super.sizes,
    super.tags,
    super.regularPrice,
    super.currentPrice,
    super.quantity,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: optionalJsonEntityId(json),
      title: requiredJsonString(json, 'title'),
      slug: requiredJsonString(json, 'slug'),
      brandId: optionalJsonId(json, 'brand'),
      categoryIds: _objectIds(json['categories']),
      description: optionalJsonString(json, 'description'),
      photos: _strings(json['photos']),
      colors: _strings(json['colors']),
      sizes: _strings(json['sizes']),
      tags: _strings(json['tags']),
      regularPrice: _double(json['regular_price']),
      currentPrice: _double(json['current_price']),
      quantity: _int(json['quantity']),
    );
  }

  static List<String> _strings(dynamic value) {
    if (value is! List) return const [];
    return value.whereType<String>().toList(growable: false);
  }

  static List<String> _objectIds(dynamic value) {
    if (value is! List) return const [];
    return value
        .map((item) {
          if (item is String) return item;
          if (item is Map) {
            final id = item['_id'] ?? item['id'];
            if (id is String) return id;
          }
          return null;
        })
        .whereType<String>()
        .toList(growable: false);
  }

  static double? _double(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static int _int(dynamic value) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'title': title,
    'slug': slug,
    if (brandId != null) 'brand': brandId,
    'categories': categoryIds,
    if (description != null) 'description': description,
    'photos': photos,
    'colors': colors,
    'sizes': sizes,
    'tags': tags,
    if (regularPrice != null) 'regular_price': regularPrice,
    if (currentPrice != null) 'current_price': currentPrice,
    'quantity': quantity,
  };
}
