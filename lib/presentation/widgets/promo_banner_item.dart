import 'dart:ui';

import 'package:ecommerce_app/core/constants/app_assets.dart';
import 'package:ecommerce_app/core/constants/app_strings.dart';

class PromoBannerItem {
  const PromoBannerItem({
    required this.title,
    this.imagePath = AppAssets.shoe,
    this.buttonLabel = AppStrings.buyNow,
    this.onTap,
  });

  final String title;
  final String imagePath;
  final String buttonLabel;
  final VoidCallback? onTap;
}
