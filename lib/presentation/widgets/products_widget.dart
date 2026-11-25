import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:ecommerce_app/presentation/widgets/product_card.dart';
import 'package:ecommerce_app/presentation/widgets/section_header.dart';
import 'package:material_ui/material_ui.dart';

class ProductsWidget extends StatelessWidget {
  const ProductsWidget({
    required this.items,
    this.title = AppStrings.popular,
    this.seeAllLabel = AppStrings.seeAll,
    this.onSeeAll,
    this.onProductTap,
    this.itemWidth = 100,
    this.itemSpacing = 14,
    this.horizontalPadding = 8,
    this.headerFontSize = 16,
    this.seeAllFontSize = 14,
    super.key,
  });

  final List<ProductItem> items;
  final String title;
  final String seeAllLabel;
  final VoidCallback? onSeeAll;
  final ValueChanged<ProductItem>? onProductTap;
  final double itemWidth;
  final double itemSpacing;
  final double horizontalPadding;
  final double headerFontSize;
  final double seeAllFontSize;

  @override
  Widget build(BuildContext context) {
    final cardDetailsHeight = itemWidth < 92 ? 48 : 56;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SectionHeader(
          title: title,
          seeAllLabel: seeAllLabel,
          onSeeAll: onSeeAll,
          titleFontSize: headerFontSize,
          seeAllFontSize: seeAllFontSize,
        ),
        SizedBox(
          height: itemWidth / 1.3 + cardDetailsHeight,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) => SizedBox(width: itemSpacing),
            itemBuilder: (context, index) {
              final item = items[index];
              final onTap =
                  item.onTap ??
                  (onProductTap == null ? null : () => onProductTap!(item));
              return SizedBox(
                width: itemWidth,
                child: ProductCard(
                  title: item.title,
                  price: item.price,
                  rating: item.rating,
                  imagePath: item.imagePath,
                  onTap: onTap,
                  isWishlisted: item.isWishlisted,
                  onWishlistTap: item.onWishlistTap,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
