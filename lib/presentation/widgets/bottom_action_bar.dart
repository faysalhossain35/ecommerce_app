import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:material_ui/material_ui.dart';

class BottomActionBar extends StatelessWidget {
  const BottomActionBar({
    required this.title,
    required this.onAction,
    this.value,
    this.actionLabel,
    this.actionIcon,
    this.actionSemanticLabel,
    super.key,
  }) : assert((actionLabel == null) != (actionIcon == null));

  final String title;
  final String? value;
  final String? actionLabel;
  final IconData? actionIcon;
  final String? actionSemanticLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                Expanded(
                  child: value == null
                      ? Text(
                          title,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 9,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              value!,
                              style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                ),
                if (actionIcon case final icon?)
                  Semantics(
                    button: true,
                    label: actionSemanticLabel ?? title,
                    child: Material(
                      color: AppColors.primary,
                      shape: const CircleBorder(),
                      child: InkWell(
                        key: const ValueKey('bottom-action-icon-button'),
                        onTap: onAction,
                        customBorder: const CircleBorder(),
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: Icon(
                            icon,
                            color: AppColors.textOnPrimary,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    width: 100,
                    height: 34,
                    child: ElevatedButton(
                      key: const ValueKey('bottom-action-label-button'),
                      onPressed: onAction,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textOnPrimary,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        actionLabel!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
