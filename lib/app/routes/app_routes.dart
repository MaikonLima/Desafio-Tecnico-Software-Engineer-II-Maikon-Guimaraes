import 'package:fake_store/app/core/data/product_repository.dart';
import 'package:flutter/material.dart';
import '../core/storage/favorites_store.dart';
import '../modules/product_module/notifiers/products_notifier.dart';
import '../modules/product_module/pages/products_page.dart';

class AppRoutes {
  static Route<dynamic> onGenerate(RouteSettings s) {
    final notifier = ProductsNotifier(ProductRepository(), FavoritesStore());
    return MaterialPageRoute(builder: (_) => HomePage(notifier: notifier));
  }
}
