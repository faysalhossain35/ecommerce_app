import 'package:ecommerce_app/data/models/slide_model.dart';
import 'package:ecommerce_app/data/service/slide_service.dart';
import 'package:ecommerce_app/domain/entities/slide.dart';
import 'package:ecommerce_app/presentation/providers/feature_provider.dart';

class SlideProvider extends FeatureProvider {
  SlideProvider({SlideService? service}) : _service = service ?? SlideService();

  final SlideService _service;
  List<Slide> _slides = [];

  List<Slide> get slides => List.unmodifiable(_slides);

  Future<void> fetchSlides({int? count, int? page}) {
    return runOperation(() async {
      _slides = await _service.getSlides(count: count, page: page);
    });
  }

  Future<void> createSlide(SlideModel slide) {
    return runOperation(() async {
      await _service.createSlide(slide);
      _slides = [..._slides, slide];
    });
  }

  Future<void> deleteSlide(String id) {
    return runOperation(() async {
      await _service.deleteSlide(id);
      _slides = _slides.where((slide) => slide.id != id).toList();
    });
  }
}
