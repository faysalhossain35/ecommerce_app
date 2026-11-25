import 'package:ecommerce_app/core/constants/app_assets.dart';
import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_ui/material_ui.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({
    this.onProfileTap,
    this.onSupportTap,
    this.onNotificationsTap,
    super.key,
  });

  final VoidCallback? onProfileTap;
  final VoidCallback? onSupportTap;
  final VoidCallback? onNotificationsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(AppAssets.logoNav, width: 82, height: 20),
        const Spacer(),
        _HeaderAction(
          icon: Icons.person_outline,
          tooltip: 'Profile',
          onPressed: onProfileTap,
        ),
        const SizedBox(width: 4),
        _HeaderAction(
          icon: Icons.call_outlined,
          tooltip: 'Support',
          onPressed: onSupportTap,
        ),
        const SizedBox(width: 4),
        _HeaderAction(
          icon: Icons.notifications_none_outlined,
          tooltip: 'Notifications',
          onPressed: onNotificationsTap,
        ),
      ],
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 15, color: AppColors.icon),
        ),
      ),
    );
  }
}
