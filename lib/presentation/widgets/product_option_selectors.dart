import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:material_ui/material_ui.dart';

class ProductColorSelector extends StatelessWidget {
  const ProductColorSelector({
    required this.colors,
    required this.selectedColor,
    required this.onSelected,
    super.key,
  });

  final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(colors.length, (index) {
        final color = colors[index];
        final isSelected = color == selectedColor;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Semantics(
            button: true,
            selected: isSelected,
            label: 'Color ${_colorName(color)}',
            child: InkWell(
              key: ValueKey('product-color-$index'),
              onTap: () => onSelected(color),
              customBorder: const CircleBorder(),
              child: Container(
                width: 23,
                height: 23,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: color == AppColors.swatchGrey
                      ? Border.all(color: AppColors.divider)
                      : null,
                ),
                alignment: Alignment.center,
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: AppColors.textOnPrimary,
                        size: 15,
                      )
                    : null,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _colorName(Color color) {
    if (color == AppColors.swatchBlack) return 'black';
    if (color == AppColors.swatchBlue) return 'blue';
    if (color == AppColors.swatchBrown) return 'brown';
    if (color == AppColors.swatchGrey) return 'gray';
    if (color == AppColors.swatchDarkGrey) return 'dark gray';
    return 'custom';
  }
}

class ProductSizeSelector extends StatelessWidget {
  const ProductSizeSelector({
    required this.sizes,
    required this.selectedSize,
    required this.onSelected,
    super.key,
  });

  final List<String> sizes;
  final String selectedSize;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: sizes.map((size) {
        final isSelected = size == selectedSize;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Semantics(
            button: true,
            selected: isSelected,
            label: 'Size $size',
            child: InkWell(
              key: ValueKey('product-size-$size'),
              onTap: () => onSelected(size),
              customBorder: const CircleBorder(),
              child: Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryDark
                      : AppColors.cardBackground,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryDark
                        : AppColors.iconInactive,
                  ),
                ),
                child: Text(
                  size,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.textOnPrimary
                        : AppColors.textSecondary,
                    fontSize: 8,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
