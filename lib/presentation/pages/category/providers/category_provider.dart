import 'package:ecommerce_app/data/models/category_model.dart';
import 'package:ecommerce_app/data/service/category_service.dart';
import 'package:ecommerce_app/domain/entities/category.dart';
import 'package:ecommerce_app/presentation/providers/feature_provider.dart';

class CategoryProvider extends FeatureProvider {
  CategoryProvider({CategoryService? service})
    : _service = service ?? CategoryService();

  final CategoryService _service;
  List<Category> _categories = [];

  List<Category> get categories => List.unmodifiable(_categories);

  Future<void> fetchCategories({int? count, int? page}) {
    return runOperation(() async {
      _categories = await _service.getCategories(
        count: count ?? 100,
        page: page,
      );
    });
  }

  Future<CategoryModel> fetchCategory(String id) {
    return runOperation(() => _service.getCategory(id));
  }

  Future<void> createCategory(CategoryModel category) {
    return runOperation(() async {
      await _service.createCategory(category);
      _categories = [..._categories, category];
    });
  }

  Future<void> updateCategory(String id, CategoryModel category) {
    return runOperation(() async {
      await _service.updateCategory(id, category);
      final index = _categories.indexWhere((item) => item.id == id);
      if (index != -1) {
        final updatedCategory = CategoryModel(
          id: id,
          title: category.title,
          slug: category.slug,
          description: category.description,
          icon: category.icon,
          parentId: category.parentId,
        );
        _categories = List.of(_categories)..[index] = updatedCategory;
      }
    });
  }

  Future<void> deleteCategory(String id) {
    return runOperation(() async {
      await _service.deleteCategory(id);
      _categories = _categories.where((category) => category.id != id).toList();
    });
  }
}
