import 'package:ecommerce_app/data/models/brand_model.dart';
import 'package:ecommerce_app/data/service/brand_service.dart';
import 'package:ecommerce_app/domain/entities/brand.dart';
import 'package:ecommerce_app/presentation/providers/feature_provider.dart';

class BrandProvider extends FeatureProvider {
  BrandProvider({BrandService? service}) : _service = service ?? BrandService();

  final BrandService _service;
  List<Brand> _brands = [];

  List<Brand> get brands => List.unmodifiable(_brands);

  Future<void> fetchBrands({int? count, int? page}) {
    return runOperation(() async {
      _brands = await _service.getBrands(count: count, page: page);
    });
  }

  Future<BrandModel> fetchBrand(String id) {
    return runOperation(() => _service.getBrand(id));
  }

  Future<void> createBrand(BrandModel brand) {
    return runOperation(() async {
      await _service.createBrand(brand);
      _brands = [..._brands, brand];
    });
  }

  Future<void> updateBrand(String id, BrandModel brand) {
    return runOperation(() async {
      await _service.updateBrand(id, brand);
      final index = _brands.indexWhere((item) => item.id == id);
      if (index != -1) {
        final updatedBrand = BrandModel(
          id: id,
          title: brand.title,
          slug: brand.slug,
          description: brand.description,
          icon: brand.icon,
        );
        _brands = List.of(_brands)..[index] = updatedBrand;
      }
    });
  }

  Future<void> deleteBrand(String id) {
    return runOperation(() async {
      await _service.deleteBrand(id);
      _brands = _brands.where((brand) => brand.id != id).toList();
    });
  }
}
