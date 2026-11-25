import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/presentation/widgets/promo_banar_card.dart';
import 'package:ecommerce_app/presentation/widgets/promo_banner_item.dart';
import 'package:material_ui/material_ui.dart';

class PromoBannerCarouselWidget extends StatefulWidget {
  const PromoBannerCarouselWidget({required this.banners, super.key});

  final List<PromoBannerItem> banners;

  @override
  State<PromoBannerCarouselWidget> createState() =>
      _PromoBannerCarouselWidgetState();
}

class _PromoBannerCarouselWidgetState extends State<PromoBannerCarouselWidget> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 2.35,
          child: PageView.builder(
            itemCount: widget.banners.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return PromoBannerCard(banner: widget.banners[index]);
            },
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.banners.length, (index) {
            return Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == _currentIndex
                    ? AppColors.primary
                    : AppColors.background,
                border: Border.all(
                  color: index == _currentIndex
                      ? AppColors.primary
                      : AppColors.border,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
