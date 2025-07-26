import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final Border? border;

  const CardContainer({
    Key? key,
    required this.child,
    this.padding,
    this.borderRadius = 16,
    this.backgroundColor,
    this.boxShadow,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: AppTheme.shadowColor,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
        border: border,
      ),
      child: child,
    );
  }
}
