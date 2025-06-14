import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/services/hive_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  final _hiveServices = HiveServices();

  // Called when: - the favorites page is opened & - After unFavorite() calling
  void getFavorites() async {
    // Emit loading state
    emit(FavoriteLoading());

    try {
      // Fetch Favorites from Hive
      final fetchedFavorites = _hiveServices.getFavorites();

      // Check if favorites are empty
      if (fetchedFavorites.isEmpty) {
        emit(FavoriteEmpty());
      } else {
        emit(FavoriteLoaded(favorites: fetchedFavorites));
      }
    } catch (e) {
      // Emit error state if Hive fetch fails
      emit(FavoriteError(message: e.toString()));
    }
  }

  void favorite(ProductItemModel product) async {
    try {
      // Add to Hive
      await _hiveServices.addFavorite(product);
    } catch (e) {
      // Emit error state if Hive add fails
      emit(FavoriteError(message: e.toString()));
    }
  }

  void unFavorite(ProductItemModel product) async {
    try {
      // Delete from Hive
      await _hiveServices.deleteFavorite(product);
    } catch (e) {
      // Emit error state if Hive delete fails
      emit(FavoriteError(message: e.toString()));
    }
  }
}
