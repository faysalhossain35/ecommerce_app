import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:ecommerce_app/presentation/widgets/product_card.dart';
import 'package:material_ui/material_ui.dart';

class ProductGridWidget extends StatelessWidget {
  const ProductGridWidget({
    required this.items,
    this.title = AppStrings.wishList,
    this.onBack,
    this.onProductTap,
    this.emptyMessage,
    this.showBackButton = true,
    this.crossAxisCount = 3,
    super.key,
  });

  final List<ProductItem> items;
  final String title;
  final VoidCallback? onBack;
  final ValueChanged<ProductItem>? onProductTap;
  final String? emptyMessage;
  final bool showBackButton;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 48,
        leadingWidth: showBackButton ? 32 : 0,
        leading: showBackButton
            ? IconButton(
                padding: EdgeInsets.zero,
                onPressed: onBack ?? () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back_ios_new, size: 16),
              )
            : null,
        titleSpacing: showBackButton ? 0 : 14,
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.divider),
        ),
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                emptyMessage ?? '',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth =
                    (constraints.maxWidth - 18 - 14 * (crossAxisCount - 1)) /
                    crossAxisCount;
                final cardDetailsHeight = itemWidth < 92 ? 48 : 56;

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(9, 10, 9, 12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: itemWidth / 1.3 + cardDetailsHeight,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final onTap =
                        item.onTap ??
                        (onProductTap == null
                            ? null
                            : () => onProductTap!(item));
                    return ProductCard(
                      title: item.title,
                      price: item.price,
                      rating: item.rating,
                      imagePath: item.imagePath,
                      onTap: onTap,
                      isWishlisted: item.isWishlisted,
                      onWishlistTap: item.onWishlistTap,
                    );
                  },
                );
              },
            ),
    );
  }
}
