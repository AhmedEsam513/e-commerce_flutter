import 'package:e_commerce/models/product_item_model.dart';
import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/services/auth_services.dart';
import 'package:e_commerce/services/home_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_tab_state.dart';

class HomeTabCubit extends Cubit<HomeTabState> {
  HomeTabCubit() : super(HomeTabInitial());

  final _homeServices = HomeServicesImpl();
  final _authServices = AuthServicesImpl();

  String getUserId() {
    final currentUserId = _authServices.getCurrentUser()!.uid;
    return currentUserId;
  }

  void getHomeTabData() async {
    emit(HomeTabLoading());

    try {
      // Fetch Products
      final fetchedProducts = await _homeServices.fetchProducts();

      // Fetch Current User
      final currentUser = await _homeServices.fetchCurrentUser(getUserId());

      // Get Current User's Favorites
      final favoritesIDs = List<String>.from(_homeServices.getFavoritesIDs());

      debugPrint("favoritesIDs : $favoritesIDs");

      // Emit HomeTabLoaded State
      emit(
        HomeTabLoaded(
          products: fetchedProducts,
          banners: homeBanners,
          user: currentUser,
          favoritesIDs: favoritesIDs,
        ),
      );
    } catch (e) {
      emit(HomeTabError(e.toString()));
    }
  }

  /*void getFavorites() {
    try {
      // Get Current User's Favorites
      final favoritesIDs = List<String>.from(_homeServices.getFavoritesIDs());

      debugPrint("favoritesIDs : $favoritesIDs");

      emit(FavoriteLoaded(favoritesIDs: favoritesIDs));
    }catch(e){
      emit(FavoriteError(message: e.toString()));
    }
  }*/

  void favorite(ProductItemModel product) async {
    try {
      // Add to Favorites (using Hive)
      await _homeServices.addToFavorites(product);

      // Emit FavoriteAdded State
      emit(FavoriteAdded(productId: product.productId!));
    } catch (e) {
      // Emit FavoriteError State if an error occurs
      emit(FavoriteError(message: e.toString()));
    }
  }

  void unFavorite(ProductItemModel product) async {
    try {
      // Remove from Favorites (using Hive)
      await _homeServices.removeFromFavorites(product);

      // Emit FavoriteRemoved State
      emit(FavoriteRemoved(productId: product.productId!));
    } catch (e) {
      // Emit FavoriteError State if an error occurs
      emit(FavoriteError(message: e.toString()));
    }
  }
}
