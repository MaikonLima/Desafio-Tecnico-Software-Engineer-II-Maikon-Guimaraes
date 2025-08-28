import 'package:shared_preferences/shared_preferences.dart';

class FavoritesStore {
  static const _key = 'favorite_ids';

  Future<Set<int>> load() async {
    final sp = await SharedPreferences.getInstance();
    final list = sp.getStringList(_key) ?? const [];
    return list.map(int.parse).toSet();
  }

  Future<void> save(Set<int> ids) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList(_key, ids.map((e) => e.toString()).toList());
  }
}
