part of 'home_tab_cubit.dart';

sealed class HomeTabState {}

final class HomeTabInitial extends HomeTabState {}

class HomeTabLoading extends HomeTabState {}

class HomeTabLoaded extends HomeTabState {
  final List<ProductItemModel> products;
  final List<Widget> banners;
  final UserModel user;
  final List<String> favoritesIDs;
  HomeTabLoaded({
    required this.products,
    required this.banners,
    required this.user,
    required this.favoritesIDs,
  });
}

class HomeTabError extends HomeTabState {
  final String message;

  HomeTabError(this.message);
}

// Favorite States
/*class FavoriteLoaded extends HomeTabState {
  final List<String> favoritesIDs;
  FavoriteLoaded({required this.favoritesIDs});
}*/

class FavoriteAdded extends HomeTabState {
  String productId;

  FavoriteAdded({required this.productId});
}

class FavoriteRemoved extends HomeTabState {
  String productId;

  FavoriteRemoved({required this.productId});
}

class FavoriteError extends HomeTabState {
  String message;

  FavoriteError({required this.message});
}
