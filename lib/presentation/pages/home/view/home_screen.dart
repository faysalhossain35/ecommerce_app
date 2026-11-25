import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:ecommerce_app/presentation/widgets/category_card.dart';
import 'package:ecommerce_app/presentation/widgets/categories_grid_widget.dart';
import 'package:ecommerce_app/presentation/widgets/home_header_widget.dart';
import 'package:ecommerce_app/presentation/widgets/home_search_widget.dart';
import 'package:ecommerce_app/presentation/pages/product/view/product_details_screen.dart';
import 'package:ecommerce_app/presentation/pages/product/view/category_products_screen.dart';
import 'package:ecommerce_app/presentation/pages/product/providers/product_provider.dart';
import 'package:ecommerce_app/presentation/widgets/product_card.dart';
import 'package:ecommerce_app/presentation/widgets/product_grid_widget.dart';
import 'package:ecommerce_app/presentation/widgets/products_widget.dart';
import 'package:ecommerce_app/presentation/widgets/promo_banner_carousel_widget.dart';
import 'package:ecommerce_app/presentation/widgets/promo_banner_item.dart';
import 'package:ecommerce_app/presentation/widgets/section_header.dart';
import 'package:ecommerce_app/presentation/pages/slide/providers/slide_provider.dart';
import 'package:ecommerce_app/presentation/pages/brand/providers/brand_provider.dart';
import 'package:ecommerce_app/presentation/pages/category/providers/category_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    this.wishlistedProductKeys = const <String>{},
    this.onWishlistChanged,
    this.onAddToCart,
    super.key,
  });

  final Set<String> wishlistedProductKeys;
  final void Function(ProductItem product, bool isWishlisted)?
  onWishlistChanged;
  final void Function(
    ProductItem product,
    int quantity,
    Color color,
    String size,
  )?
  onAddToCart;

  static const categories = [
    CategoryItem(title: 'Electronics', icon: Icons.desktop_windows_outlined),
    CategoryItem(title: 'Food', icon: Icons.ramen_dining_outlined),
    CategoryItem(title: 'Fashion', icon: Icons.diamond_outlined),
    CategoryItem(title: 'Furniture', icon: Icons.king_bed_outlined),
  ];

  static const allCategories = [
    ...categories,
    ...categories,
    ...categories,
    ...categories,
  ];

  static const _featuredProducts = [
    ProductItem(title: 'New Year Special Shoe 30', price: '\$100', rating: 4.8),
    ProductItem(title: 'New Year Special Shoe 30', price: '\$100', rating: 4.8),
    ProductItem(title: 'New Year Special Shoe 30', price: '\$100', rating: 4.8),
  ];

  static const products = [
    ..._featuredProducts,
    ProductItem(title: 'New Year Special Sneaker', price: '\$110', rating: 4.7),
    ProductItem(title: 'Blue Running Shoe', price: '\$95', rating: 4.6),
    ProductItem(title: 'Everyday Walking Shoe', price: '\$130', rating: 4.9),
    ProductItem(title: 'Classic Sport Shoe', price: '\$85', rating: 4.5),
  ];

  static const _banners = [
    PromoBannerItem(title: AppStrings.bannerTitle),
    PromoBannerItem(title: 'Fresh Styles\nNew Season\nShop Now'),
    PromoBannerItem(title: 'Limited Offer\nSpecial Deal\nSave 30%'),
    PromoBannerItem(title: 'Popular Picks\nFind Your Style\nBuy Now'),
  ];

  List<PromoBannerItem> _bannersFromProvider(BuildContext context) {
    try {
      final slideProvider = context.watch<SlideProvider>();
      if (slideProvider.slides.isNotEmpty) {
        return slideProvider.slides
            .where((slide) => slide.photoUrl.trim().isNotEmpty)
            .map(
              (slide) => PromoBannerItem(
                title: slide.description?.trim().isNotEmpty == true
                    ? slide.description!
                    : AppStrings.bannerTitle,
                imagePath: slide.photoUrl,
              ),
            )
            .toList(growable: false);
      }
    } on ProviderNotFoundException {
      // Standalone widget tests and embeds do not require a Provider.
    }
    return _banners;
  }

  Widget _brandSection(BuildContext context) {
    try {
      final provider = context.watch<BrandProvider>();
      final brands = provider.brands;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _brandsHeader(),
          if (brands.isEmpty)
            SizedBox(
              height: 74,
              child: Center(
                child: Text(
                  provider.isLoading
                      ? 'Loading brands...'
                      : 'No brands available',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 78,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                scrollDirection: Axis.horizontal,
                itemCount: brands.length,
                separatorBuilder: (context, index) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  return SizedBox(
                    width: 58,
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: brand.icon == null || brand.icon!.isEmpty
                              ? const Icon(
                                  Icons.storefront_outlined,
                                  color: AppColors.primaryDark,
                                  size: 24,
                                )
                              : Image.network(
                                  brand.icon!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.storefront_outlined,
                                        color: AppColors.primaryDark,
                                        size: 24,
                                      ),
                                ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          brand.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      );
    } on ProviderNotFoundException {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _brandsHeader(),
          const SizedBox(
            height: 74,
            child: Center(
              child: Text(
                'No brands available',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 10),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _brandsHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(8, 0, 8, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          AppStrings.brands,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  List<CategoryItem> _categoryItems(List categories) {
    return categories
        .map(
          (category) => CategoryItem(
            id: category.id,
            title: category.title,
            icon: Icons.category_outlined,
            imageUrl: category.icon,
          ),
        )
        .toList(growable: false);
  }

  Widget _categorySection(BuildContext context, double categoryWidth) {
    var items = HomeScreen.categories;
    try {
      final provider = context.watch<CategoryProvider>();
      if (provider.categories.isNotEmpty) {
        items = _categoryItems(provider.categories);
      } else if (provider.isLoading) {
        return const SizedBox(
          height: 74,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 1.5,
            ),
          ),
        );
      } else if (provider.errorMessage != null) {
        return SizedBox(
          height: 74,
          child: Center(
            child: Text(
              provider.errorMessage!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.error, fontSize: 10),
            ),
          ),
        );
      }
    } on ProviderNotFoundException {
      // Standalone widget tests and embeds can use the static fallback.
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items.take(4).map((category) {
        final iconBoxSize = categoryWidth - 4;
        return CategoryCard(
          title: category.title,
          icon: category.icon,
          imageUrl: category.imageUrl,
          onTap: () => _openCategory(context, category),
          width: categoryWidth,
          iconBoxSize: iconBoxSize,
          iconSize: iconBoxSize * 0.52,
          labelFontSize: 9,
        );
      }).toList(),
    );
  }

  void _openProductGrid(BuildContext context, String title) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductGridWidget(
          title: title,
          items: _productsWithWishlist(context, products),
          onProductTap: (product) => _openProductDetails(context, product),
        ),
      ),
    );
  }

  void _openCategory(BuildContext context, CategoryItem category) {
    if (category.id != null) {
      try {
        context.read<ProductProvider>();
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => CategoryProductsScreen(
              categoryId: category.id!,
              categoryTitle: category.title,
              onProductTap: (product) => _openProductDetails(context, product),
            ),
          ),
        );
        return;
      } on ProviderNotFoundException {
        // Standalone widget tests and embeds use the sample product grid.
      }
    }
    _openProductGrid(context, category.title);
  }

  void _openProductDetails(BuildContext context, ProductItem product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailsScreen(
          title: product.title,
          price: product.price,
          rating: product.rating,
          imagePaths: List.filled(4, product.imagePath),
          initialWishlisted: wishlistedProductKeys.contains(product.productKey),
          onWishlistChanged: (isWishlisted) =>
              onWishlistChanged?.call(product, isWishlisted),
          onAddToCart: onAddToCart == null
              ? null
              : (quantity, color, size) =>
                    onAddToCart!(product, quantity, color, size),
        ),
      ),
    );
  }

  List<ProductItem> _productsWithWishlist(
    BuildContext context,
    List<ProductItem> items,
  ) {
    return items.map((product) {
      final isWishlisted = wishlistedProductKeys.contains(product.productKey);
      return product.copyWith(
        isWishlisted: isWishlisted,
        onTap: () => _openProductDetails(context, product),
        onWishlistTap: onWishlistChanged == null
            ? product.onWishlistTap
            : () => onWishlistChanged!(product, !isWishlisted),
      );
    }).toList();
  }

  void _openCategoriesGrid(BuildContext context) {
    var items = allCategories;
    try {
      final categories = context.read<CategoryProvider>().categories;
      if (categories.isNotEmpty) {
        items = _categoryItems(categories);
      }
    } on ProviderNotFoundException {
      // Standalone widget tests and embeds can use the static fallback.
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CategoriesGridWidget(
          items: items,
          onCategoryTap: (category) => _openCategory(context, category),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final categoryWidth = ((constraints.maxWidth - 32) / 4)
                .clamp(46.0, 70.0)
                .toDouble();
            final itemWidth = ((constraints.maxWidth - 36) / 3)
                .clamp(54.0, 120.0)
                .toDouble();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 8),
                    child: HomeHeaderWidget(),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 8),
                    child: HomeSearchWidget(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: PromoBannerCarouselWidget(
                      banners: _bannersFromProvider(context),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        SectionHeader(
                          title: AppStrings.allCategories,
                          onSeeAll: () => _openCategoriesGrid(context),
                          titleFontSize: 12,
                          seeAllFontSize: 9,
                          horizontalPadding: 0,
                          bottomPadding: 6,
                        ),
                        _categorySection(context, categoryWidth),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _brandSection(context),
                  const SizedBox(height: 7),
                  ProductsWidget(
                    title: AppStrings.special,
                    items: _productsWithWishlist(context, _featuredProducts),
                    onProductTap: (product) =>
                        _openProductDetails(context, product),
                    onSeeAll: () =>
                        _openProductGrid(context, AppStrings.special),
                    itemWidth: itemWidth,
                    //itemSpacing: 10,
                    horizontalPadding: 8,
                    headerFontSize: 12,
                    seeAllFontSize: 9,
                  ),
                  const SizedBox(height: 7),
                  ProductsWidget(
                    title: AppStrings.newArrival,
                    items: _productsWithWishlist(context, _featuredProducts),
                    onProductTap: (product) =>
                        _openProductDetails(context, product),
                    onSeeAll: () =>
                        _openProductGrid(context, AppStrings.newArrival),
                    itemWidth: itemWidth,
                    //itemSpacing: 10,
                    horizontalPadding: 8,
                    headerFontSize: 12,
                    seeAllFontSize: 9,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
