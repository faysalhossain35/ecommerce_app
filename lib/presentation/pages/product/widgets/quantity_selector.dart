import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/presentation/pages/product/widgets/quantity_button.dart';
import 'package:material_ui/material_ui.dart';

class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
  });

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        QuantityButton(
          icon: Icons.remove,
          enabled: quantity > 1,
          onTap: () => onChanged(quantity - 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            quantity.toString().padLeft(2, '0'),
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 10),
          ),
        ),
        QuantityButton(icon: Icons.add, onTap: () => onChanged(quantity + 1)),
      ],
    );
  }
}
