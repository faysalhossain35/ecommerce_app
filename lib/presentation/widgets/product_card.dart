import 'package:ecommerce_app/core/constants/app_assets.dart';
import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:material_ui/material_ui.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.title,
    required this.price,
    required this.rating,
    this.imagePath = AppAssets.shoe,
    this.onTap,
    this.isWishlisted = false,
    this.onWishlistTap,
    super.key,
  });

  final String title;
  final String price;
  final double rating;
  final String imagePath;
  final VoidCallback? onTap;
  final bool isWishlisted;
  final VoidCallback? onWishlistTap;

  @override
  Widget build(BuildContext context) {
    final isNetworkImage =
        imagePath.startsWith('http://') || imagePath.startsWith('https://');
    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.cardBackground,
      elevation: 2,
      shadowColor: AppColors.border,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: Container(
                color: AppColors.primaryLight,
                padding: const EdgeInsets.all(8),
                child: isNetworkImage
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(AppAssets.shoe, fit: BoxFit.contain),
                      )
                    : Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 7, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxWidth < 76;
                      final wishlistButtonSize = isCompact ? 16.0 : 24.0;
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              price,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.primaryDark,
                                fontSize: isCompact ? 8 : 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.star,
                            color: AppColors.accent,
                            size: isCompact ? 9 : 12,
                          ),
                          SizedBox(width: isCompact ? 1 : 2),
                          Text(
                            rating.toStringAsFixed(1),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: isCompact ? 8 : 9,
                            ),
                          ),
                          SizedBox(width: isCompact ? 1 : 5),
                          Semantics(
                            button: true,
                            enabled: onWishlistTap != null,
                            label: isWishlisted
                                ? 'Remove from wish list'
                                : 'Add to wish list',
                            child: InkWell(
                              key: const ValueKey('product-wishlist-button'),
                              onTap: onWishlistTap,
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                width: wishlistButtonSize,
                                height: isCompact ? 15 : 22,
                                // decoration: BoxDecoration(
                                //   color: AppColors.primary,
                                //   borderRadius: BorderRadius.circular(4),
                                // ),
                                alignment: Alignment.center,
                                child: Icon(
                                  isWishlisted
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: AppColors.primary,
                                  size: isCompact ? 10 : 15,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductItem {
  const ProductItem({
    required this.title,
    required this.price,
    required this.rating,
    this.id,
    this.imagePath = AppAssets.shoe,
    this.onTap,
    this.isWishlisted = false,
    this.onWishlistTap,
  });

  final String title;
  final String price;
  final double rating;
  final String? id;
  final String imagePath;
  final VoidCallback? onTap;
  final bool isWishlisted;
  final VoidCallback? onWishlistTap;

  String get productKey => id ?? '$title|$price|$imagePath';

  ProductItem copyWith({
    String? id,
    VoidCallback? onTap,
    bool? isWishlisted,
    VoidCallback? onWishlistTap,
  }) {
    return ProductItem(
      title: title,
      price: price,
      rating: rating,
      id: id ?? this.id,
      imagePath: imagePath,
      onTap: onTap ?? this.onTap,
      isWishlisted: isWishlisted ?? this.isWishlisted,
      onWishlistTap: onWishlistTap ?? this.onWishlistTap,
    );
  }
}
