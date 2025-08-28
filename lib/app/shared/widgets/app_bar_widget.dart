import 'package:fake_store/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Color backgroundColor;
  final Color titleColor;
  final PreferredSizeWidget? bottom;

  const AppBarWidget({
    super.key,
    required this.title,
    this.actions,
    this.backgroundColor = Colors.white,
    this.titleColor = Colors.black,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
          color: AppColors.title,
        ),
      ),
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(bottom != null ? 112 : kToolbarHeight);
}
