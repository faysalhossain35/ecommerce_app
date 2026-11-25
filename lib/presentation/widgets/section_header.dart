import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:material_ui/material_ui.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    this.onSeeAll,
    this.seeAllLabel = AppStrings.seeAll,
    this.titleFontSize = 14,
    this.seeAllFontSize = 10,
    this.horizontalPadding = 10,
    this.bottomPadding = 8,
    super.key,
  });

  final String title;
  final VoidCallback? onSeeAll;
  final String seeAllLabel;
  final double titleFontSize;
  final double seeAllFontSize;
  final double horizontalPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        0,
        horizontalPadding,
        bottomPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primaryDark,
              disabledForegroundColor: AppColors.primaryDark,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: TextStyle(fontSize: seeAllFontSize),
            ),
            child: Text(seeAllLabel),
          ),
        ],
      ),
    );
  }
}
