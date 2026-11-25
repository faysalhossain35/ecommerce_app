import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:ecommerce_app/presentation/pages/review/view/reviews_screen.dart';
import 'package:ecommerce_app/presentation/pages/product/widgets/product_details_content.dart';
import 'package:ecommerce_app/presentation/widgets/bottom_action_bar.dart';
import 'package:ecommerce_app/presentation/widgets/product_image_gallery.dart';
import 'package:material_ui/material_ui.dart';

typedef AddProductToCartCallback = void Function(
  int quantity,
  Color color,
  String size,
);

const _defaultDescription =
    'Reference site about Lorem Ipsum, giving information on its origins, as '
    'well as a random Lipsum generator Reference site about Lorem Ipsum, '
    'well as a random Lipsum generator Reference site about Lorem Ipsum, '
    'well as a random Lipsum generator Reference site about Lorem Ipsum, '
    'giving information on its origins, as well as a random Lipsum generator.';

const _defaultColors = [
  AppColors.swatchBlack,
  AppColors.swatchBlue,
  AppColors.swatchBrown,
  AppColors.swatchGrey,
  AppColors.swatchDarkGrey,
];

const _defaultSizes = ['X', 'XL', '2L', '3L'];

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({
    this.title = 'Happy New Year Special Deal Save 30%',
    this.price = '\$1,000',
    this.rating = 4.8,
    this.reviewCount = 1000,
    this.description = _defaultDescription,
    this.imagePaths = defaultProductImages,
    this.colors = _defaultColors,
    this.sizes = _defaultSizes,
    this.initialColor = AppColors.swatchBlue,
    this.initialSize = 'XL',
    this.initialWishlisted = false,
    this.onBack,
    this.onReviewsTap,
    this.onWishlistChanged,
    this.onAddToCart,
    super.key,
  });

  final String title;
  final String price;
  final double rating;
  final int reviewCount;
  final String description;
  final List<String> imagePaths;
  final List<Color> colors;
  final List<String> sizes;
  final Color initialColor;
  final String initialSize;
  final bool initialWishlisted;
  final VoidCallback? onBack;
  final VoidCallback? onReviewsTap;
  final ValueChanged<bool>? onWishlistChanged;
  final AddProductToCartCallback? onAddToCart;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Color _selectedColor;
  late String _selectedSize;
  int _quantity = 1;
  bool _isWishlisted = false;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    _selectedSize = widget.initialSize;
    _isWishlisted = widget.initialWishlisted;
  }

  void _openReviews() {
    final onReviewsTap = widget.onReviewsTap;
    if (onReviewsTap != null) {
      onReviewsTap();
      return;
    }

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => ReviewsScreen(reviewCount: widget.reviewCount),
      ),
    );
  }

  void _toggleWishlist() {
    setState(() => _isWishlisted = !_isWishlisted);
    widget.onWishlistChanged?.call(_isWishlisted);
  }

  void _addToCart() {
    final onAddToCart = widget.onAddToCart;
    if (onAddToCart != null) {
      onAddToCart(_quantity, _selectedColor, _selectedSize);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.addToCartUnavailable)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 48,
        flexibleSpace: const Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: 2,
            width: double.infinity,
            child: ColoredBox(color: AppColors.primary),
          ),
        ),
        leadingWidth: 32,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: widget.onBack ?? () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 16),
        ),
        titleSpacing: 0,
        title: const Text(
          AppStrings.productDetails,
          style: TextStyle(
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
      body: Column(
        children: [
          ProductImageGallery(imagePaths: widget.imagePaths),
          Expanded(
            child: ProductDetailsContent(
              title: widget.title,
              rating: widget.rating,
              description: widget.description,
              colors: widget.colors,
              selectedColor: _selectedColor,
              onColorSelected: (color) =>
                  setState(() => _selectedColor = color),
              sizes: widget.sizes,
              selectedSize: _selectedSize,
              onSizeSelected: (size) => setState(() => _selectedSize = size),
              quantity: _quantity,
              onQuantityChanged: (quantity) =>
                  setState(() => _quantity = quantity),
              isWishlisted: _isWishlisted,
              onWishlistTap: _toggleWishlist,
              onReviewsTap: _openReviews,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        title: AppStrings.price,
        value: widget.price,
        actionLabel: AppStrings.addToCart,
        onAction: _addToCart,
      ),
    );
  }
}
