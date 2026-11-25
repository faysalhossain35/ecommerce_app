import 'package:ecommerce_app/core/constants/app_colors.dart';
import 'package:ecommerce_app/core/constants/app_strings.dart';
import 'package:ecommerce_app/presentation/widgets/bottom_action_bar.dart';
import 'package:ecommerce_app/presentation/pages/cart/widgets/cart_item_card.dart';
import 'package:material_ui/material_ui.dart';

const _sampleCartItems = [
  CartItemData(
    title: 'New Year Special Shoe',
    price: 100,
    color: 'Red',
    size: 'X',
  ),
  CartItemData(
    title: 'New Year Special Shoe',
    price: 100,
    color: 'Red',
    size: 'X',
  ),
  CartItemData(
    title: 'New Year Special Shoe',
    price: 100,
    color: 'Red',
    size: 'X',
  ),
  CartItemData(
    title: 'New Year Special Shoe',
    price: 100,
    color: 'Red',
    size: 'X',
  ),
];

class CartScreen extends StatefulWidget {
  const CartScreen({
    this.items = _sampleCartItems,
    this.initialTotalPrice = 100000,
    this.onBack,
    this.onCheckout,
    this.onItemsChanged,
    super.key,
  });

  final List<CartItemData> items;
  final double? initialTotalPrice;
  final VoidCallback? onBack;
  final VoidCallback? onCheckout;
  final ValueChanged<List<CartItemData>>? onItemsChanged;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItemData> _items;
  late double _totalPrice;

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.items);
    _totalPrice =
        widget.initialTotalPrice ??
        _items.fold(0, (total, item) => total + item.price * item.quantity);
  }

  @override
  void didUpdateWidget(CartScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.items, oldWidget.items) ||
        widget.initialTotalPrice != oldWidget.initialTotalPrice) {
      _items = List.of(widget.items);
      _totalPrice =
          widget.initialTotalPrice ??
          _items.fold(0, (total, item) => total + item.price * item.quantity);
    }
  }

  void _updateQuantity(int index, int quantity) {
    final item = _items[index];
    setState(() {
      _totalPrice += (quantity - item.quantity) * item.price;
      _items[index] = item.copyWith(quantity: quantity);
    });
    widget.onItemsChanged?.call(List.of(_items));
  }

  void _removeItem(int index) {
    setState(() {
      final item = _items[index];
      _totalPrice -= item.price * item.quantity;
      _items.removeAt(index);
    });
    widget.onItemsChanged?.call(List.of(_items));
  }

  void _checkout() {
    final onCheckout = widget.onCheckout;
    if (onCheckout != null) {
      onCheckout();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppStrings.checkoutUnavailable)),
    );
  }

  String _formatTotal(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final wholeAmount = parts.first.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );
    return '\$$wholeAmount.${parts.last}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 48,
        flexibleSpace: const Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: 2,
            width: double.infinity,
            child: ColoredBox(color: AppColors.primary),
          ),
        ),
        leadingWidth: 32,
        leading: IconButton(
          padding: EdgeInsets.zero,
          onPressed: widget.onBack ?? () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_ios_new, size: 16),
        ),
        titleSpacing: 0,
        title: const Text(
          AppStrings.cart,
          style: TextStyle(
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
      body: _items.isEmpty
          ? const Center(
              child: Text(
                AppStrings.cartEmpty,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(10, 14, 10, 12),
              itemCount: _items.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) => CartItemCard(
                key: ValueKey('cart-item-$index'),
                item: _items[index],
                onRemove: () => _removeItem(index),
                onQuantityChanged: (quantity) =>
                    _updateQuantity(index, quantity),
              ),
            ),
      bottomNavigationBar: BottomActionBar(
        title: AppStrings.totalPrice,
        value: _formatTotal(_totalPrice),
        actionLabel: AppStrings.checkout,
        onAction: _checkout,
      ),
    );
  }
}
