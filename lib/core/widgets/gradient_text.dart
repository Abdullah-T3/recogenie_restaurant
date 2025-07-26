import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final List<Color>? colors;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const GradientText({
    super.key,
    required this.text,
    this.style,
    this.colors,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: colors ?? [AppTheme.primaryColor, AppTheme.primaryDarkColor],
      ).createShader(bounds),
      child: Text(
        text,
        style:
            style?.copyWith(color: Colors.white) ??
            AppTheme.headline2.copyWith(color: Colors.white),
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
