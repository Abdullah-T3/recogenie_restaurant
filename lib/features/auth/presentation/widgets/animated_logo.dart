import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AnimatedLogo extends StatelessWidget {
  final double size;
  final IconData icon;
  final Color? color;
  final Duration? duration;
  final VoidCallback? onTap;

  const AnimatedLogo({
    Key? key,
    this.size = 120,
    this.icon = Icons.restaurant_menu,
    this.color,
    this.duration,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: duration ?? const Duration(milliseconds: 2000),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    (color ?? AppTheme.primaryColor).withOpacity(0.1),
                    (color ?? AppTheme.primaryColor).withOpacity(0.2),
                  ],
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: (color ?? AppTheme.primaryColor).withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (color ?? AppTheme.primaryColor).withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: size * 0.5,
                color: color ?? AppTheme.primaryColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
