import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PriceDisplay extends StatelessWidget {
  final double price;
  final TextStyle? style;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool showCurrency;
  final String currencySymbol;

  const PriceDisplay({
    super.key,
    required this.price,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.showCurrency = true,
    this.currencySymbol = '\$',
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '${showCurrency ? currencySymbol : ''}${price.toStringAsFixed(2)}',
      style:
          style ??
          AppTheme.headline4.copyWith(
            fontSize: fontSize ?? 16,
            color: color ?? AppTheme.primaryColor,
            fontWeight: fontWeight ?? FontWeight.bold,
          ),
    );
  }
}
