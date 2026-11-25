import 'dart:convert';

import 'package:ecommerce_app/core/constants/end_points.dart';
import 'package:ecommerce_app/data/models/slide_model.dart';
import 'package:ecommerce_app/data/service/api_service_helpers.dart';
import 'package:ecommerce_app/data/service/network/network_caller.dart';

class SlideService {
  SlideService({NetworkCaller? networkCaller})
    : _networkCaller = networkCaller ?? NetworkCaller();

  final NetworkCaller _networkCaller;

  Future<List<SlideModel>> getSlides({int? count, int? page}) async {
    final response = await _networkCaller.get(
      buildCollectionUri(EndPoints.slides, count: count, page: page),
      headers: await buildApiHeaders(),
    );
    return ApiResponseParser.list(
      response,
      resourceName: 'slides',
    ).map(SlideModel.fromJson).toList(growable: false);
  }

  Future<void> createSlide(SlideModel slide) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.createSlide),
      headers: await buildApiHeaders(authenticated: true, jsonBody: true),
      body: jsonEncode(_requestBody(slide)),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Future<void> deleteSlide(String id) async {
    final response = await _networkCaller.delete(
      Uri.parse(EndPoints.deleteSlide(id)),
      headers: await buildApiHeaders(authenticated: true),
    );
    ApiResponseParser.ensureSuccess(response);
  }

  Map<String, dynamic> _requestBody(SlideModel slide) =>
      slide.toJson()..remove('_id');
}
