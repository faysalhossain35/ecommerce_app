import 'package:ecommerce_app/core/constants/app_assets.dart';
import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/presentation/pages/product/providers/product_provider.dart';
import 'package:ecommerce_app/presentation/widgets/product_card.dart';
import 'package:ecommerce_app/presentation/widgets/product_grid_widget.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class CategoryProductsScreen extends StatefulWidget {
  const CategoryProductsScreen({
    required this.categoryId,
    required this.categoryTitle,
    this.onProductTap,
    super.key,
  });

  final String categoryId;
  final String categoryTitle;
  final ValueChanged<ProductItem>? onProductTap;

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProducts());
  }

  Future<void> _loadProducts() async {
    try {
      await context.read<ProductProvider>().fetchProducts(
        count: 100,
        categoryId: widget.categoryId,
      );
    } catch (_) {
      // ProductProvider exposes the request error to this screen.
    }
  }

  List<ProductItem> _toProductItems(ProductProvider provider) {
    return provider.products
        .map((product) {
          final price = product.currentPrice ?? product.regularPrice ?? 0;
          return ProductItem(
            id: product.id,
            title: product.title,
            price: '\$${price.toStringAsFixed(0)}',
            rating: 0,
            imagePath: product.photos.isEmpty
                ? AppAssets.shoe
                : product.photos.first,
          );
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _statusScreen(message: 'Loading products...', isLoading: true);
        }
        if (provider.errorMessage != null) {
          return _statusScreen(message: provider.errorMessage!);
        }
        return ProductGridWidget(
          title: widget.categoryTitle,
          items: _toProductItems(provider),
          emptyMessage: 'No products found in this category.',
          onProductTap: widget.onProductTap,
        );
      },
    );
  }

  Widget _statusScreen({required String message, bool isLoading = false}) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 48,
        leadingWidth: 32,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 16),
        ),
        titleSpacing: 0,
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(color: AppColors.primary)
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
      ),
    );
  }
}
