part of 'product_details_cubit.dart';

sealed class ProductDetailsState {}

final class ProductDetailsInitial extends ProductDetailsState {}

class ProductDetailsLoading extends ProductDetailsState {}

class ProductDetailsLoaded extends ProductDetailsState {
  bool isFavorite;

  ProductDetailsLoaded(this.isFavorite);
}

class ProductDetailsError extends ProductDetailsState {
  final String error;

  ProductDetailsError(this.error);
}

// Quantity State
class QuantityChangedState extends ProductDetailsState {
  final int newQuantity;

  QuantityChangedState({required this.newQuantity});
}

// Size State
class SizeSelectedState extends ProductDetailsState {
  ProductSizes selectedSize;

  SizeSelectedState({required this.selectedSize});
}

// Add To Cart States
class AddingToCartState extends ProductDetailsState {}

class AddedToCartState extends ProductDetailsState {}

class AddToCartErrorState extends ProductDetailsState {
  final String message;

  AddToCartErrorState(this.message);
}

// Favorite States
class FavoriteAdded extends ProductDetailsState {}

class FavoriteRemoved extends ProductDetailsState {}

class FavoriteError extends ProductDetailsState {
  String message;

  FavoriteError({required this.message});
}
