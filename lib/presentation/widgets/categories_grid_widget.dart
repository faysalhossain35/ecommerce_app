import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:ecommerce_app/presentation/widgets/category_card.dart';
import 'package:material_ui/material_ui.dart';

class CategoriesGridWidget extends StatelessWidget {
  const CategoriesGridWidget({
    required this.items,
    this.title = AppStrings.categories,
    this.onCategoryTap,
    this.crossAxisCount = 4,
    super.key,
  });

  final List<CategoryItem> items;
  final String title;
  final ValueChanged<CategoryItem>? onCategoryTap;
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
        leadingWidth: 32,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 16),
        ),
        titleSpacing: 0,
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth =
              (constraints.maxWidth - 24 - 6 * (crossAxisCount - 1)) /
              crossAxisCount;
          final iconBoxSize = itemWidth.clamp(48.0, 56.0).toDouble();

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 6,
              mainAxisSpacing: 0,
              mainAxisExtent: 90,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Align(
                alignment: Alignment.topCenter,
                child: CategoryCard(
                  title: item.title,
                  icon: item.icon,
                  onTap: onCategoryTap == null
                      ? null
                      : () => onCategoryTap!(item),
                  width: itemWidth,
                  iconBoxSize: iconBoxSize,
                  iconSize: iconBoxSize * 0.55,
                  labelFontSize: 10,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
