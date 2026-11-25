import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:ecommerce_app/presentation/pages/cart/view/cart_screen.dart';
import 'package:ecommerce_app/presentation/pages/cart/widgets/cart_item_card.dart';
import 'package:ecommerce_app/presentation/pages/home/view/home_screen.dart';
import 'package:ecommerce_app/presentation/pages/product/view/product_details_screen.dart';
import 'package:ecommerce_app/presentation/pages/product/view/category_products_screen.dart';
import 'package:ecommerce_app/presentation/pages/product/providers/product_provider.dart';
import 'package:ecommerce_app/presentation/pages/wishlist/view/wishlist_screen.dart';
import 'package:ecommerce_app/presentation/widgets/app_bottom_navigation_bar.dart';
import 'package:ecommerce_app/presentation/widgets/category_card.dart';
import 'package:ecommerce_app/presentation/widgets/categories_grid_widget.dart';
import 'package:ecommerce_app/presentation/widgets/product_card.dart';
import 'package:ecommerce_app/presentation/widgets/product_grid_widget.dart';
import 'package:ecommerce_app/presentation/pages/category/providers/category_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  var _currentIndex = 0;
  List<CartItemData> _cartItems = [];
  final Map<String, ProductItem> _wishlistedProducts = {};

  List<ProductItem> _productsWithWishlistState(List<ProductItem> products) {
    return products.map((product) {
      final isWishlisted = _wishlistedProducts.containsKey(product.productKey);
      return product.copyWith(
        isWishlisted: isWishlisted,
        onTap: () => _openProductDetails(product),
        onWishlistTap: () => _updateWishlist(product, !isWishlisted),
      );
    }).toList();
  }

  List<ProductItem> _wishlistItems() {
    return _wishlistedProducts.values.map((product) {
      return product.copyWith(
        isWishlisted: true,
        onTap: () => _openProductDetails(product),
        onWishlistTap: () => _updateWishlist(product, false),
      );
    }).toList();
  }

  void _updateWishlist(ProductItem product, bool isWishlisted) {
    setState(() {
      if (isWishlisted) {
        _wishlistedProducts[product.productKey] = product;
      } else {
        _wishlistedProducts.remove(product.productKey);
      }
    });
  }

  void _updateCartItems(List<CartItemData> items) {
    setState(() => _cartItems = List.of(items));
  }

  void _addToCart(ProductItem product, int quantity, Color color, String size) {
    final colorName = _colorName(color);
    final price = _parsePrice(product.price);
    final existingIndex = _cartItems.indexWhere(
      (item) =>
          item.productId == product.productKey &&
          item.color == colorName &&
          item.size == size,
    );

    setState(() {
      if (existingIndex == -1) {
        _cartItems = [
          ..._cartItems,
          CartItemData(
            title: product.title,
            price: price,
            color: colorName,
            size: size,
            productId: product.productKey,
            quantity: quantity,
            imagePath: product.imagePath,
          ),
        ];
      } else {
        final existingItem = _cartItems[existingIndex];
        _cartItems = List.of(_cartItems)
          ..[existingIndex] = existingItem.copyWith(
            quantity: existingItem.quantity + quantity,
          );
      }
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text(AppStrings.addedToCart)));
  }

  double _parsePrice(String formattedPrice) {
    final numericPrice = formattedPrice.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.parse(numericPrice);
  }

  String _colorName(Color color) {
    if (color == AppColors.swatchBlack) return 'Black';
    if (color == AppColors.swatchBlue) return 'Blue';
    if (color == AppColors.swatchBrown) return 'Brown';
    if (color == AppColors.swatchGrey) return 'Grey';
    if (color == AppColors.swatchDarkGrey) return 'Dark Grey';
    return 'Custom';
  }

  void _openCategory(CategoryItem category) {
    if (category.id != null) {
      try {
        context.read<ProductProvider>();
        Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => CategoryProductsScreen(
              categoryId: category.id!,
              categoryTitle: category.title,
              onProductTap: _openProductDetails,
            ),
          ),
        );
        return;
      } on ProviderNotFoundException {
        // Standalone widget tests and embeds use the sample product grid.
      }
    }
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ProductGridWidget(
          title: category.title,
          items: _productsWithWishlistState(HomeScreen.products),
          onProductTap: _openProductDetails,
        ),
      ),
    );
  }

  List<CategoryItem> _categories(BuildContext context) {
    try {
      final categories = context.watch<CategoryProvider>().categories;
      if (categories.isNotEmpty) {
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
    } on ProviderNotFoundException {
      // Standalone widget tests and embeds can use the static fallback.
    }
    return HomeScreen.allCategories;
  }

  void _openProductDetails(ProductItem product) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailsScreen(
          title: product.title,
          price: product.price,
          rating: product.rating,
          imagePaths: List.filled(4, product.imagePath),
          initialWishlisted: _wishlistedProducts.containsKey(
            product.productKey,
          ),
          onWishlistChanged: (isWishlisted) =>
              _updateWishlist(product, isWishlisted),
          onAddToCart: (quantity, color, size) =>
              _addToCart(product, quantity, color, size),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
        wishlistedProductKeys: _wishlistedProducts.keys.toSet(),
        onWishlistChanged: _updateWishlist,
        onAddToCart: _addToCart,
      ),
      CategoriesGridWidget(
        items: _categories(context),
        onCategoryTap: _openCategory,
      ),
      CartScreen(
        items: _cartItems,
        initialTotalPrice: null,
        onItemsChanged: _updateCartItems,
      ),
      WishlistScreen(
        items: _wishlistItems(),
        onProductTap: _openProductDetails,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        cartItemCount: _cartItems.fold(
          0,
          (total, item) => total + item.quantity,
        ),
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
