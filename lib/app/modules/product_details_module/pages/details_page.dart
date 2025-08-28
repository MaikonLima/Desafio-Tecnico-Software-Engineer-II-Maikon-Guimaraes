import 'package:fake_store/app/core/constants/app_images.dart';
import 'package:fake_store/app/core/constants/app_strings.dart';
import 'package:fake_store/app/core/data/models/product.dart';
import 'package:fake_store/app/core/data/product_repository.dart';
import 'package:fake_store/app/core/theme/app_colors.dart';
import 'package:fake_store/app/core/theme/app_fonts.dart';
import 'package:fake_store/app/shared/utils/string_extensions.dart';
import 'package:fake_store/app/shared/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import '../../product_module/notifiers/products_notifier.dart';

class ProductDetailsPage extends StatefulWidget {
  final int id;
  final ProductsNotifier notifier;

  const ProductDetailsPage({
    super.key,
    required this.id,
    required this.notifier,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Product? product;
  bool loading = true;
  Object? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Product? _findIn(List<Product> list, int id) {
    for (final p in list) {
      if (p.id == id) return p;
    }
    return null;
  }

  Future<void> _load() async {
    try {
      final cachedList =
          (widget.notifier.value.data as List<Product>?) ?? const <Product>[];
      product =
          _findIn(cachedList, widget.id) ??
          _findIn(widget.notifier.favoriteProducts, widget.id);

      product ??= await ProductRepository().fetchById(widget.id);
    } catch (e) {
      error = e;
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = widget.notifier.favorites.contains(widget.id);

    return Scaffold(
      backgroundColor: AppColors.backgroundApp,
      appBar: AppBarWidget(
        title: AppStrings.detailsTitle,
        actions: [
          IconButton(
            onPressed: () async {
              await widget.notifier.toggleFavorite(widget.id);
              if (mounted) setState(() {});
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : null,
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(AppStrings.errorLoadingDetails))
          : product == null
          ? const Center(child: Text(AppStrings.errorSearchProduct))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.network(product!.image, height: 200)),
                  const SizedBox(height: 16),
                  Text(
                    product!.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, size: 18, color: Colors.amber[700]),
                          const SizedBox(width: 4),
                          Text(
                            '${product!.rating.toStringAsFixed(1)} '
                            '(${product!.ratingCount} reviews)',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$${product!.price.toStringAsFixed(2)}',
                        style: AppFonts.priceGreen,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15, top: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppImages.alignRight,
                          width: 22,
                          height: 22,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          product!.category.toLowerCase().capitalize(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.paragraph,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Icon(Icons.menu, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          product!.description,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: AppColors.paragraph,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
