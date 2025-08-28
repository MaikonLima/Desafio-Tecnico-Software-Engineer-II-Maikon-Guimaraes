import 'package:flutter/material.dart';
import 'package:fake_store/app/core/constants/app_strings.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String hintText;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry margin;

  const SearchInput({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText = AppStrings.searchHint,
    this.height = 48,
    this.borderRadius = 14,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final background = theme.brightness == Brightness.dark
        ? theme.colorScheme.surfaceVariant.withOpacity(0.35)
        : const Color(0xFFEFEFEF);

    final hintColor = theme.brightness == Brightness.dark
        ? Colors.grey.shade400
        : Colors.grey.shade600;

    return Container(
      margin: margin,
      height: height,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          autofocus: false,
          textInputAction: TextInputAction.search,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
          decoration: InputDecoration(
            isCollapsed: true,
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: hintColor,
            ),
            prefixIcon: const Padding(
              padding: EdgeInsets.only(left: 12, right: 4),
              child: Icon(Icons.search, size: 22),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}
