import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../Responsive/models/DeviceInfo.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final VoidCallback? onClear;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool showClearButton;
  final EdgeInsetsGeometry? contentPadding;

  const SearchTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    this.onClear,
    this.prefixIcon = Icons.search,
    this.suffixIcon,
    this.showClearButton = true,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (_) {
        FocusScope.of(context).unfocus();
      },
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTheme.bodyText2.copyWith(color: AppTheme.textHintColor),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppTheme.textSecondaryColor)
            : null,
        suffixIcon: _buildSuffixIcon(),
        border: InputBorder.none,
        contentPadding: contentPadding,
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (showClearButton && controller.text.isNotEmpty) {
      return IconButton(
        icon: Icon(Icons.clear, color: AppTheme.textSecondaryColor),
        onPressed: () {
          controller.clear();
          onClear?.call();
        },
      );
    } else if (suffixIcon != null) {
      return Icon(suffixIcon, color: AppTheme.textSecondaryColor);
    }
    return null;
  }
}
