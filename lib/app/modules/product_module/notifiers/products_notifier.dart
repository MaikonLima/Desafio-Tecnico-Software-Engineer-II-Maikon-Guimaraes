import 'dart:async';
import 'package:fake_store/app/core/data/models/product.dart';
import 'package:fake_store/app/core/data/product_repository.dart';
import 'package:fake_store/app/core/storage/favorites_store.dart';
import 'package:fake_store/app/core/ui/ui_state.dart/ui_state.dart';
import 'package:flutter/foundation.dart';

class ProductsNotifier extends ValueNotifier<UiState<List<Product>>> {
  final ProductRepository? _repo;
  final FavoritesStore? _store;

  List<Product> _all = [];
  Set<int> favorites = {};
  String query = '';
  Timer? _debounce;

  ProductsNotifier([this._repo, this._store]) : super(const UiState.idle());

  Future<void> init() async {
    assert(
      _repo != null && _store != null,
      'Repository and Store must be provided for init.',
    );
    favorites = await _store!.load();
    await loadProducts();
    if (query.isNotEmpty) _applyFilter();
  }

  Future<void> loadProducts() async {
    value = const UiState.loading();
    try {
      _all = await _repo!.fetchAll();
      _applyFilter();
    } catch (e) {
      value = UiState.error(e);
    }
  }

  void setQuery(String q) {
    query = q;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), _applyFilter);
  }

  void _applyFilter() {
    final q = query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? _all
        : _all.where((p) => p.title.toLowerCase().contains(q)).toList();
    value = UiState.success(filtered);
  }

  Future<void> toggleFavorite(int id) async {
    if (_store == null) return;

    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    await _store!.save(favorites);
    notifyListeners();
  }

  List<Product> get favoriteProducts =>
      _all.where((p) => favorites.contains(p.id)).toList();

  void setProducts(List<Product> products) {
    _all = products;
    _applyFilter();
  }

  void setLoading() {
    value = const UiState.loading();
  }

  void setError(Object error) {
    value = UiState.error(error);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
