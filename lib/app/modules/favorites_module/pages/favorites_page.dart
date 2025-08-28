import 'package:fake_store/app/core/constants/app_images.dart';
import 'package:fake_store/app/core/constants/app_strings.dart';
import 'package:fake_store/app/core/data/models/product.dart';
import 'package:fake_store/app/core/theme/app_colors.dart';
import 'package:fake_store/app/core/ui/ui_state.dart/ui_state.dart';
import 'package:fake_store/app/modules/product_details_module/pages/details_page.dart';
import 'package:fake_store/app/shared/widgets/app_bar_widget.dart';
import 'package:fake_store/app/shared/widgets/empty_list_widget.dart';
import 'package:flutter/material.dart';
import '../../product_module/notifiers/products_notifier.dart';
import '../../../shared/widgets/product_card.dart';

class FavoritesPage extends StatelessWidget {
  final ProductsNotifier notifier;
  const FavoritesPage({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundApp,
      appBar: AppBarWidget(title: AppStrings.favoritesTitle),
      body: ValueListenableBuilder<UiState<List<Product>>>(
        valueListenable: notifier,
        builder: (_, __, ___) {
          final favs = notifier.favoriteProducts;
          if (favs.isEmpty) {
            return const EmptyListWidget(imageAsset: AppImages.emptyList);
          }
          return ListView.builder(
            itemCount: favs.length,
            itemBuilder: (_, i) {
              final p = favs[i];
              final isFav = notifier.favorites.contains(p.id);
              return ProductCard(
                product: p,
                isFavorite: isFav,
                onToggleFavorite: () => notifier.toggleFavorite(p.id),
                onOpen: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        ProductDetailsPage(id: p.id, notifier: notifier),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
