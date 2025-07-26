import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../Responsive/models/DeviceInfo.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final Function(int) onQuantityChanged;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;
  final double? borderRadius;
  final bool showTotalPrice;
  final double? itemPrice;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
    this.borderRadius,
    this.showTotalPrice = false,
    this.itemPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                if (quantity > 1) {
                  onQuantityChanged(quantity - 1);
                }
              },
              icon: Icon(
                Icons.remove_circle_outline,
                color: iconColor ?? AppTheme.primaryColor,
              ),
            ),
            Container(
              width: width ?? 40,
              height: height ?? 32,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    backgroundColor ?? AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
              ),
              child: Center(
                child: Text(
                  '$quantity',
                  style: AppTheme.bodyText1.copyWith(
                    color: textColor ?? AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                onQuantityChanged(quantity + 1);
              },
              icon: Icon(
                Icons.add_circle_outline,
                color: iconColor ?? AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        if (showTotalPrice && itemPrice != null) ...[
          const SizedBox(height: 8),
          Text(
            '\$${(itemPrice! * quantity).toStringAsFixed(2)}',
            style: AppTheme.bodyText2.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
        ],
      ],
    );
  }
}
