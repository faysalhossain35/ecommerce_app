import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:material_ui/material_ui.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    required this.currentIndex,
    required this.onDestinationSelected,
    this.cartItemCount = 0,
    super.key,
  }) : assert(currentIndex >= 0 && currentIndex < _items.length),
       assert(cartItemCount >= 0);

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;
  final int cartItemCount;

  static const _items = [
    (label: 'Home', icon: Icons.home_outlined),
    (label: 'Categories', icon: Icons.grid_view_outlined),
    (label: 'Cart', icon: Icons.shopping_basket_outlined),
    (label: 'Wish', icon: Icons.card_giftcard_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 90,
          child: Row(
            children: [
              for (var index = 0; index < _items.length; index++)
                Expanded(
                  child: _NavigationDestination(
                    label: _items[index].label,
                    icon: _items[index].icon,
                    isSelected: index == currentIndex,
                    badgeCount: _items[index].label == 'Cart'
                        ? cartItemCount
                        : 0,
                    onTap: () => onDestinationSelected(index),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationDestination extends StatelessWidget {
  const _NavigationDestination({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.badgeCount,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final int badgeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.logoTeal : AppColors.textSecondary;

    return Semantics(
      button: true,
      selected: isSelected,
      label: badgeCount == 0
          ? label
          : '$label, $badgeCount ${badgeCount == 1 ? 'item' : 'items'}',
      child: InkWell(
        key: ValueKey('bottom-navigation-${label.toLowerCase()}'),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 40, color: color),
                if (badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -9,
                    child: ExcludeSemantics(
                      child: Container(
                        key: const ValueKey('cart-count-badge'),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          badgeCount > 99 ? '99+' : '$badgeCount',
                          style: const TextStyle(
                            color: AppColors.textOnPrimary,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
