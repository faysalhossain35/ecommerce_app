import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/core/constants/app_assets.dart';
import 'package:ecommerce_app/presentation/widgets/promo_banner_item.dart';
import 'package:material_ui/material_ui.dart';

class PromoBannerCard extends StatelessWidget {
  const PromoBannerCard({super.key, required this.banner});

  final PromoBannerItem banner;

  @override
  Widget build(BuildContext context) {
    final isNetworkImage =
        banner.imagePath.startsWith('http://') ||
        banner.imagePath.startsWith('https://');
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(7),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 2, 8),
              child: isNetworkImage
                  ? Image.network(
                      banner.imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset(AppAssets.shoe, fit: BoxFit.contain),
                    )
                  : Image.asset(banner.imagePath, fit: BoxFit.contain),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    banner.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: 11,
                      height: 1.15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 20,
                    child: TextButton(
                      onPressed: banner.onTap,
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.background,
                        foregroundColor: AppColors.primaryDark,
                        disabledForegroundColor: AppColors.primaryDark,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        textStyle: const TextStyle(fontSize: 7),
                      ),
                      child: Text(banner.buttonLabel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
