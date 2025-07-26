import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../Responsive/models/DeviceInfo.dart';

class CategoryBadge extends StatelessWidget {
  final String category;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final double? fontSize;

  const CategoryBadge({
    super.key,
    required this.category,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(borderRadius ?? 12),
      ),
      child: Text(
        category,
        style:
            textStyle ??
            AppTheme.bodyText2.copyWith(
              fontSize: fontSize ?? 12,
              color: textColor ?? AppTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
