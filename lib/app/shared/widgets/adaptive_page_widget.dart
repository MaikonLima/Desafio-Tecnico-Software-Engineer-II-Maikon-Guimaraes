import 'package:flutter/material.dart';
import 'package:fake_store/app/shared/widgets/adaptive_widget.dart';

class AdaptivePage extends StatelessWidget {
  final Widget child;
  const AdaptivePage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final maxW = Adaptive.bodyMaxWidth(context);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Padding(padding: Adaptive.pagePadding(context), child: child),
      ),
    );
  }
}
