import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../Responsive/models/DeviceInfo.dart';
import 'cached_image_widget.dart';

class ItemCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String? description;
  final String? category;
  final double price;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String cacheKey;
  final double? imageWidth;
  final double? imageHeight;
  final double? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final List<BoxShadow>? boxShadow;
  final Color? backgroundColor;
  final double font;
  const ItemCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.description,
    this.category,
    required this.price,
    this.trailing,
    this.onTap,
    required this.cacheKey,
    this.imageWidth,
    this.imageHeight,
    this.borderRadius,
    this.margin,
    this.padding,
    this.boxShadow,
    this.backgroundColor,
    required this.font,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: AppTheme.shadowColor,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius ?? 16),
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: Row(
              children: [
                CachedImageWidget(
                  imageUrl: imageUrl,
                  width: imageWidth ?? 80,
                  height: imageHeight ?? 80,
                  borderRadius: borderRadius ?? 8,
                  cacheKey: cacheKey,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.headline4.copyWith(
                          color: AppTheme.textPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: font,
                        ),
                      ),
                      if (category != null) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            category!,
                            style: AppTheme.bodyText2.copyWith(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                      if (description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          description!,
                          style: AppTheme.bodyText2.copyWith(
                            color: AppTheme.textSecondaryColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: AppTheme.headline4.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
