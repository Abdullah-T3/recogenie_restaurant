import 'package:flutter/material.dart';
import 'package:recogenie_restaurant/core/Responsive/models/DeviceInfo.dart';
import '../theme/app_theme.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final List<Color>? colors;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;
  final Deviceinfo deviceinfo;
  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.colors,
    this.textStyle,
    this.borderRadius,
    required this.deviceinfo,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: deviceinfo.screenHeight * 0.07,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLoading
                ? [AppTheme.textHintColor, AppTheme.textHintColor]
                : colors ?? [AppTheme.primaryColor, AppTheme.primaryDarkColor],
          ),
          borderRadius:
              borderRadius ??
              BorderRadius.circular(deviceinfo.screenWidth * 0.05),
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: deviceinfo.screenWidth * 0.02,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius:
                borderRadius ??
                BorderRadius.circular(deviceinfo.screenWidth * 0.05),
            onTap: isLoading ? null : onPressed,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: deviceinfo.screenWidth * 0.06,
                      height: deviceinfo.screenWidth * 0.06,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(
                            icon,
                            color: Colors.white,
                            size: deviceinfo.screenWidth * 0.05,
                          ),
                          SizedBox(width: deviceinfo.screenWidth * 0.02),
                        ],
                        Text(
                          text,
                          style:
                              textStyle ??
                              AppTheme.button.copyWith(
                                fontSize: deviceinfo.screenWidth * 0.04,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
