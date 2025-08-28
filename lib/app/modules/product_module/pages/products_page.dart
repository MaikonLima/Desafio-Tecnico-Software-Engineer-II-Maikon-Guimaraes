import 'package:fake_store/app/core/constants/app_strings.dart';
import 'package:fake_store/app/core/theme/app_colors.dart';
import 'package:fake_store/app/core/ui/ui_state.dart/ui_state.dart';
import 'package:fake_store/app/modules/product_details_module/pages/details_page.dart';
import 'package:fake_store/app/modules/error_module/pages/error_page.dart';
import 'package:fake_store/app/modules/favorites_module/pages/favorites_page.dart';
import 'package:fake_store/app/shared/widgets/adaptive_page_widget.dart';
import 'package:fake_store/app/shared/widgets/adaptive_widget.dart';
import 'package:fake_store/app/shared/widgets/app_bar_widget.dart';
import 'package:fake_store/app/shared/widgets/empty_list_widget.dart';
import 'package:fake_store/app/shared/widgets/search_input.dart';
import 'package:flutter/material.dart';
import '../notifiers/products_notifier.dart';
import '../../../shared/widgets/product_card.dart';

class HomePage extends StatefulWidget {
  final ProductsNotifier notifier;
  const HomePage({super.key, required this.notifier});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController searchCtrl;

  @override
  void initState() {
    super.initState();
    searchCtrl = TextEditingController(text: widget.notifier.query);
    widget.notifier.init();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = widget.notifier;
    final isWide = Adaptive.isDesktop(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundApp,
      appBar: isWide
          ? AppBarWidget(
              title: AppStrings.homeTitle,
              actions: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FavoritesPage(notifier: notifier),
                      ),
                    );
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: SearchInput(
                    controller: searchCtrl,
                    onChanged: notifier.setQuery,
                    height: 48,
                    borderRadius: 14,
                  ),
                ),
              ),
            )
          : AppBarWidget(
              title: AppStrings.homeTitle,
              actions: [
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => FavoritesPage(notifier: notifier),
                      ),
                    );
                  },
                ),
              ],
            ),
      body: AdaptivePage(
        child: Column(
          children: [
            const SizedBox(height: 12),
            if (MediaQuery.of(context).size.width < 600)
              SearchInput(
                controller: searchCtrl,
                onChanged: notifier.setQuery,
                margin: const EdgeInsets.only(bottom: 12),
                height: 48,
                borderRadius: 14,
              ),
            Expanded(
              child: ValueListenableBuilder<UiState<List<dynamic>>>(
                valueListenable: notifier,
                builder: (_, state, __) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.isError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final kind = ErrorScreen.classify(state.error!);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => ErrorScreen(
                            kind: kind,
                            onGoHome: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => HomePage(notifier: notifier),
                                ),
                                (route) => false,
                              );
                            },
                          ),
                        ),
                      );
                    });

                    return const SizedBox();
                  }

                  final items = (state.data ?? []);

                  if (items.isEmpty) {
                    return const EmptyListWidget(
                      imageAsset: 'assets/images/empty_list.png',
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: notifier.loadProducts,
                    child: isWide
                        ? GridView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            itemCount: items.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      3, // ou 2, dependendo da largura
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.85,
                                ),
                            itemBuilder: (_, i) {
                              final p = items[i];
                              final fav = notifier.favorites.contains(p.id);
                              return ProductCard(
                                product: p,
                                isFavorite: fav,
                                onToggleFavorite: () =>
                                    notifier.toggleFavorite(p.id),
                                onOpen: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailsPage(
                                      id: p.id,
                                      notifier: notifier,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 12),
                            itemCount: items.length,
                            itemBuilder: (_, i) {
                              final p = items[i];
                              final fav = notifier.favorites.contains(p.id);
                              return ProductCard(
                                product: p,
                                isFavorite: fav,
                                onToggleFavorite: () =>
                                    notifier.toggleFavorite(p.id),
                                onOpen: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailsPage(
                                      id: p.id,
                                      notifier: notifier,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    // ListView.builder(
                    //   itemCount: items.length,
                    //   itemBuilder: (_, i) {
                    //     final p = items[i];
                    //     final fav = notifier.favorites.contains(p.id);
                    //     return ProductCard(
                    //       product: p,
                    //       isFavorite: fav,
                    //       onToggleFavorite: () => notifier.toggleFavorite(p.id),
                    //       onOpen: () => Navigator.of(context).push(
                    //         MaterialPageRoute(
                    //           builder: (_) => ProductDetailsPage(
                    //             id: p.id,
                    //             notifier: notifier,
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
