import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:material_ui/material_ui.dart';

class QuantityButton extends StatelessWidget {
  const QuantityButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? AppColors.primary : AppColors.primaryLight,
      borderRadius: BorderRadius.circular(3),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(3),
        child: SizedBox(
          width: 18,
          height: 17,
          child: Icon(icon, color: AppColors.textOnPrimary, size: 12),
        ),
      ),
    );
  }
}
