import 'package:ecommerce_app/core/constants/app_assets.dart';
import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:material_ui/material_ui.dart';

class ProductImageGallery extends StatefulWidget {
  const ProductImageGallery({
    required this.imagePaths,
    this.height = 184,
    super.key,
  }) : assert(imagePaths.length > 0);

  final List<String> imagePaths;
  final double height;

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProductImageGallery oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imagePaths.length != oldWidget.imagePaths.length) {
      _currentPage = _currentPage.clamp(0, widget.imagePaths.length - 1);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController.hasClients) {
          _pageController.jumpToPage(_currentPage);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imagePaths.length,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (context, index) {
              final imagePath = widget.imagePaths[index];
              final isNetworkImage =
                  imagePath.startsWith('http://') ||
                  imagePath.startsWith('https://');
              return Container(
                color: AppColors.surface,
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 20),
                child: isNetworkImage
                    ? Image.network(
                        imagePath,
                        key: ValueKey('product-image-$index'),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(AppAssets.shoe, fit: BoxFit.contain),
                      )
                    : Image.asset(
                        imagePath,
                        key: ValueKey('product-image-$index'),
                        fit: BoxFit.contain,
                      ),
              );
            },
          ),
          if (widget.imagePaths.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(widget.imagePaths.length, (index) {
                  final isSelected = index == _currentPage;
                  return Semantics(
                    button: true,
                    selected: isSelected,
                    label: 'Show product image ${index + 1}',
                    child: InkWell(
                      key: ValueKey('product-image-indicator-$index'),
                      customBorder: const CircleBorder(),
                      onTap: () => _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.cardBackground,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

const defaultProductImages = [
  AppAssets.shoe,
  AppAssets.shoe,
  AppAssets.shoe,
  AppAssets.shoe,
];
