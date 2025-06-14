part of 'favorite_cubit.dart';

sealed class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<ProductItemModel> favorites;

  FavoriteLoaded({required this.favorites});
}

class FavoriteError extends FavoriteState {
  final String message;

  FavoriteError({required this.message});
}

class FavoriteEmpty extends FavoriteState {}
