import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:ecommerce_app/presentation/widgets/product_card.dart';
import 'package:ecommerce_app/presentation/widgets/product_grid_widget.dart';
import 'package:material_ui/material_ui.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({this.items = const [], this.onProductTap, super.key});

  final List<ProductItem> items;
  final ValueChanged<ProductItem>? onProductTap;

  @override
  Widget build(BuildContext context) {
    return ProductGridWidget(
      items: items,
      title: AppStrings.wishList,
      emptyMessage: AppStrings.wishListEmpty,
      showBackButton: false,
      onProductTap: onProductTap,
    );
  }
}
