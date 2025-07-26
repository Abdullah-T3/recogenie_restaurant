import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_theme.dart';

class CachedImageWidget extends StatelessWidget {
  final String? imageUrl;
  final double width;
  final double height;
  final double borderRadius;
  final String cacheKey;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedImageWidget({
    super.key,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    required this.cacheKey,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: AppTheme.backgroundColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: fit,
                memCacheWidth: (width * 2).toInt(),
                memCacheHeight: (height * 2).toInt(),
                maxWidthDiskCache: (width * 2).toInt(),
                maxHeightDiskCache: (height * 2).toInt(),
                cacheKey: cacheKey,
                placeholder: (context, url) =>
                    placeholder ??
                    Container(
                      color: AppTheme.backgroundColor,
                      child: const Icon(
                        Icons.restaurant,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                errorWidget: (context, url, error) =>
                    errorWidget ??
                    Container(
                      color: AppTheme.backgroundColor,
                      child: const Icon(
                        Icons.error,
                        color: AppTheme.errorColor,
                      ),
                    ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: AppTheme.backgroundColor,
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
      ),
    );
  }
}
