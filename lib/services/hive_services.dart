import 'package:e_commerce/models/product_item_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveServices {
  final _favoritesBox = Hive.box<ProductItemModel>("favorites");

  // Initialize Hive, register adapter and open the box
  // Called in main()
  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ProductItemModelAdapter());
    await Hive.openBox<ProductItemModel>("favorites");
  }

  Future<void> addFavorite(ProductItemModel product) async {
    await _favoritesBox.put(product.productId, product);
  }

  Future<void> deleteFavorite(ProductItemModel product) async {
    await _favoritesBox.delete(product.productId);
  }

  Future<void> clearFavorites() async {
    await _favoritesBox.clear();
  }

  List<ProductItemModel> getFavorites() {
    final favorites = _favoritesBox.values.toList();
    return favorites;
  }

  List<dynamic> getFavoritesIDs() {
    return _favoritesBox.keys.toList();
  }
}
