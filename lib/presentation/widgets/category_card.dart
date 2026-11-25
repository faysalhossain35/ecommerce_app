import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:material_ui/material_ui.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.title,
    this.icon = Icons.category_outlined,
    this.imageUrl,
    this.onTap,
    this.width = 82,
    this.iconBoxSize = 68,
    this.iconSize = 32,
    this.labelFontSize = 12,
    super.key,
  });

  final String title;
  final IconData icon;
  final String? imageUrl;
  final VoidCallback? onTap;
  final double width;
  final double iconBoxSize;
  final double iconSize;
  final double labelFontSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: iconBoxSize,
              height: iconBoxSize,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: imageUrl == null || imageUrl!.isEmpty
                  ? Icon(icon, size: iconSize, color: AppColors.primaryDark)
                  : Image.network(
                      imageUrl!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        icon,
                        size: iconSize,
                        color: AppColors.primaryDark,
                      ),
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: labelFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem {
  const CategoryItem({
    required this.title,
    required this.icon,
    this.id,
    this.imageUrl,
  });

  final String? id;
  final String title;
  final IconData icon;
  final String? imageUrl;
}
