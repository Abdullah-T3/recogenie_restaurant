import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../Responsive/models/DeviceInfo.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final double iconSize;
  final Color? iconColor;
  final Color? titleColor;
  final Color? subtitleColor;
  final Widget? actionButton;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconSize = 80,
    this.iconColor,
    this.titleColor,
    this.subtitleColor,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? AppTheme.textSecondaryColor,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTheme.headline4.copyWith(
              color: titleColor ?? AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: AppTheme.bodyText2.copyWith(
                color: subtitleColor ?? AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (actionButton != null) ...[
            const SizedBox(height: 24),
            actionButton!,
          ],
        ],
      ),
    );
  }
}
