import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';

class Adaptive {
  static bool get isWeb => kIsWeb;
  static TargetPlatform get platform => defaultTargetPlatform;

  static bool isDesktop(BuildContext context) {
    if (kIsWeb) {
      final w = MediaQuery.sizeOf(context).width;
      return w >= 900;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
        return true;
      default:
        return false;
    }
  }

  static double bodyMaxWidth(BuildContext c) =>
      isDesktop(c) ? 960 : double.infinity;

  static EdgeInsets pagePadding(BuildContext c) => isDesktop(c)
      ? const EdgeInsets.symmetric(horizontal: 24, vertical: 16)
      : const EdgeInsets.symmetric(horizontal: 12, vertical: 10);

  static double iconSizeSm(BuildContext c) => isDesktop(c) ? 20 : 18;
  static double fontSm(BuildContext c) => isDesktop(c) ? 14 : 13;
  static double fontBase(BuildContext c) => isDesktop(c) ? 16 : 15;
  static double fontLg(BuildContext c) => isDesktop(c) ? 18 : 16;

  static double radiusMd(BuildContext c) => isDesktop(c) ? 12 : 14;
}
