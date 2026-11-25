import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:ecommerce_app/presentation/pages/product/widgets/quantity_selector.dart';
import 'package:ecommerce_app/presentation/widgets/product_option_selectors.dart';
import 'package:material_ui/material_ui.dart';

class ProductDetailsContent extends StatelessWidget {
  const ProductDetailsContent({
    required this.title,
    required this.rating,
    required this.description,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
    required this.quantity,
    required this.onQuantityChanged,
    required this.isWishlisted,
    required this.onWishlistTap,
    required this.onReviewsTap,
    super.key,
  });

  final String title;
  final double rating;
  final String description;
  final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;
  final List<String> sizes;
  final String selectedSize;
  final ValueChanged<String> onSizeSelected;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final bool isWishlisted;
  final VoidCallback onWishlistTap;
  final VoidCallback onReviewsTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(14, 11, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              QuantitySelector(
                quantity: quantity,
                onChanged: onQuantityChanged,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.star, color: AppColors.accent, size: 17),
              const SizedBox(width: 3),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 13),
              InkWell(
                onTap: onReviewsTap,
                child: Text(
                  AppStrings.reviews,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Semantics(
                button: true,
                label: isWishlisted
                    ? 'Remove from wish list'
                    : 'Add to wish list',
                child: InkWell(
                  key: const ValueKey('product-details-wishlist'),
                  onTap: onWishlistTap,
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    width: 19,
                    height: 19,
                    child: Icon(
                      isWishlisted ? Icons.favorite : Icons.favorite_border,
                      color: AppColors.primaryDark,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          const Text(
            AppStrings.productColor,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 6),
          ProductColorSelector(
            colors: colors,
            selectedColor: selectedColor,
            onSelected: onColorSelected,
          ),
          const SizedBox(height: 10),
          const Text(
            AppStrings.productSize,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 6),
          ProductSizeSelector(
            sizes: sizes,
            selectedSize: selectedSize,
            onSelected: onSizeSelected,
          ),
          const SizedBox(height: 12),
          const Text(
            AppStrings.productDescription,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
