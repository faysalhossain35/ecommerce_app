import 'package:ecommerce_app/core/constants/app_assets.dart';
import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:material_ui/material_ui.dart';

class CartItemData {
  const CartItemData({
    required this.title,
    required this.price,
    required this.color,
    required this.size,
    this.productId,
    this.quantity = 1,
    this.imagePath = AppAssets.shoe,
  });

  final String title;
  final double price;
  final String color;
  final String size;
  final String? productId;
  final int quantity;
  final String imagePath;

  CartItemData copyWith({int? quantity}) {
    return CartItemData(
      title: title,
      price: price,
      color: color,
      size: size,
      productId: productId,
      quantity: quantity ?? this.quantity,
      imagePath: imagePath,
    );
  }
}

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    required this.item,
    required this.onRemove,
    required this.onQuantityChanged,
    super.key,
  });

  final CartItemData item;
  final VoidCallback onRemove;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.shimmer),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shimmer,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 68,
            child:
                item.imagePath.startsWith('http://') ||
                    item.imagePath.startsWith('https://')
                ? Image.network(
                    item.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset(AppAssets.shoe, fit: BoxFit.contain),
                  )
                : Image.asset(item.imagePath, fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 22,
                      height: 24,
                      child: IconButton(
                        tooltip: AppStrings.removeFromCart,
                        padding: EdgeInsets.zero,
                        onPressed: onRemove,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.iconInactive,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Color: ${item.color}, Size: ${item.size}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 8,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      '\$${_formatWholeAmount(item.price)}',
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    _QuantityButton(
                      icon: Icons.remove,
                      semanticLabel: AppStrings.decreaseQuantity,
                      backgroundColor: AppColors.primaryLight,
                      onTap: item.quantity > 1
                          ? () => onQuantityChanged(item.quantity - 1)
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        item.quantity.toString().padLeft(2, '0'),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add,
                      semanticLabel: AppStrings.increaseQuantity,
                      backgroundColor: AppColors.primary,
                      onTap: () => onQuantityChanged(item.quantity + 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatWholeAmount(double amount) {
    final wholeAmount = amount.toStringAsFixed(0);
    return wholeAmount.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.semanticLabel,
    required this.backgroundColor,
    required this.onTap,
  });

  final IconData icon;
  final String semanticLabel;
  final Color backgroundColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: semanticLabel,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(3),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(
            width: 18,
            height: 17,
            child: Icon(icon, color: AppColors.textOnPrimary, size: 12),
          ),
        ),
      ),
    );
  }
}
