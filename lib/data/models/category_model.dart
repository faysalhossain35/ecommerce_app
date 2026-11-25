import 'package:ecommerce_app/data/models/model_json_helpers.dart';
import 'package:ecommerce_app/domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    super.id,
    required super.title,
    required super.slug,
    super.description,
    super.icon,
    super.parentId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: optionalJsonEntityId(json),
      title: requiredJsonString(json, 'title'),
      slug: requiredJsonString(json, 'slug'),
      description: optionalJsonString(json, 'description'),
      icon: optionalJsonString(json, 'icon'),
      parentId: optionalJsonId(json, 'parent'),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'title': title,
    'slug': slug,
    if (description != null) 'description': description,
    if (icon != null) 'icon': icon,
    if (parentId != null) 'parent': parentId,
  };
}
