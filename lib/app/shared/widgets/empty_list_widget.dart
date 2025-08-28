import 'package:flutter/material.dart';

class EmptyListWidget extends StatelessWidget {
  final String imageAsset;

  const EmptyListWidget({
    super.key,
    this.imageAsset = 'assets/images/empty_list.png',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gray = theme.colorScheme.onSurface.withOpacity(0.55);

    return Center(child: Image.asset(imageAsset, width: 200, height: 200));
  }
}
